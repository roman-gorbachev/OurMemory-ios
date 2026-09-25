import Foundation

@Observable
final class SubmissionReviewViewModel {
    private(set) var submissionReviewUiState = SubmissionReviewUiState.loading

    @ObservationIgnored private let submissionId: String
    @ObservationIgnored private let moderationRepository: ModerationRepository
    @ObservationIgnored private let veteransRepository: VeteransRepository
    @ObservationIgnored private var submission: Submission?
    @ObservationIgnored private var veteranName = ""
    @ObservationIgnored private var photoUrls: [String] = []
    @ObservationIgnored private var editedText: String?
    @ObservationIgnored private var reply: String?
    @ObservationIgnored private var deselectedUrls = Set<String>()
    @ObservationIgnored private var isProcessing = false
    @ObservationIgnored private var hasFailed = false
    @ObservationIgnored private var isFinished = false

    init(submissionId: String, moderationRepository: ModerationRepository, veteransRepository: VeteransRepository) {
        self.submissionId = submissionId
        self.moderationRepository = moderationRepository
        self.veteransRepository = veteransRepository
    }

    func load() async {
        guard submission == nil else {
            return
        }
        do {
            guard let loaded = try await moderationRepository.submissionsPublisher().values.first(where: { _ in return true })?
                .first(where: { return $0.id == submissionId }) else {
                submissionReviewUiState = .error
                return
            }
            let name = await VeteranNamesLoader.names(from: veteransRepository)[loaded.veteranId] ?? ""
            veteranName = name.isBlank ? loaded.veteranId : name
            photoUrls = try await moderationRepository.resolvePhotoUrls(loaded.photoPaths)
            submission = loaded
            rebuild()
        } catch {
            submissionReviewUiState = .error
        }
    }

    func onAction(_ action: SubmissionReviewUserAction) {
        switch action {
        case .textChanged(let text):
            editedText = text
        case .replyChanged(let text):
            reply = text
        case .photoToggled(let url):
            if deselectedUrls.contains(url) {
                deselectedUrls.remove(url)
            } else {
                deselectedUrls.insert(url)
            }
        case .approve:
            approve()
            return
        case .reject:
            reject()
            return
        }
        rebuild()
    }

    private func approve() {
        guard let submission else {
            return
        }
        let approval = SubmissionApproval(
            submission: submission,
            editedText: editedText ?? submission.text,
            approvedPhotoUrls: photoUrls.filter { return !deselectedUrls.contains($0) },
            photoCaption: L10n.string("from_family_archive"),
            reply: reply ?? submission.reply
        )
        runDecision { [moderationRepository] in
            try await moderationRepository.approve(approval)
        }
    }

    private func reject() {
        let text = reply ?? submission?.reply ?? ""
        runDecision { [moderationRepository, submissionId] in
            try await moderationRepository.reject(submissionId: submissionId, reply: text)
        }
    }

    private func runDecision(_ decision: @escaping () async throws -> Void) {
        guard !isProcessing else {
            return
        }
        isProcessing = true
        hasFailed = false
        rebuild()
        Task {
            do {
                try await decision()
                isFinished = true
            } catch {
                hasFailed = true
            }
            isProcessing = false
            rebuild()
        }
    }

    private func rebuild() {
        guard let submission else {
            return
        }
        submissionReviewUiState = .success(data: SubmissionReviewUiData(
            veteranName: veteranName,
            contact: submission.contact,
            date: DisplayDate.text(fromMilliseconds: submission.createdAt),
            text: editedText ?? submission.text,
            reply: reply ?? submission.reply,
            photos: photoUrls.map { return ReviewPhotoUi(url: $0, isSelected: !deselectedUrls.contains($0)) },
            status: submission.status,
            isProcessing: isProcessing,
            hasFailed: hasFailed,
            isFinished: isFinished
        ))
    }
}
