import Foundation

@Observable
final class SubmissionReviewViewModel {
    private(set) var submissionReviewUiState = SubmissionReviewUiState.loading

    @ObservationIgnored private let submissionId: String
    @ObservationIgnored private let moderationRepository: ModerationRepository
    @ObservationIgnored private let veteransRepository: VeteransRepository
    @ObservationIgnored private let analysisRepository: SubmissionAnalysisRepository
    @ObservationIgnored private var submission: Submission?
    @ObservationIgnored private var veteranName = ""
    @ObservationIgnored private var photoUrls: [String] = []
    @ObservationIgnored private var editedText: String?
    @ObservationIgnored private var reply: String?
    @ObservationIgnored private var deselectedUrls = Set<String>()
    @ObservationIgnored private var isProcessing = false
    @ObservationIgnored private var failure: ReviewFailure?
    @ObservationIgnored private var isFinished = false
    @ObservationIgnored private var analysis: SubmissionAnalysis?
    @ObservationIgnored private var isAnalyzing = false
    @ObservationIgnored private var analysisFailed = false

    init(
        submissionId: String,
        moderationRepository: ModerationRepository,
        veteransRepository: VeteransRepository,
        analysisRepository: SubmissionAnalysisRepository
    ) {
        self.submissionId = submissionId
        self.moderationRepository = moderationRepository
        self.veteransRepository = veteransRepository
        self.analysisRepository = analysisRepository
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
        case .analyze:
            analyze()
            return
        case .applySuggestedText:
            editedText = analysis?.suggestedText ?? editedText
        case .applySuggestedReply:
            reply = analysis?.suggestedReply ?? reply
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

    private func analyze() {
        guard let submission, !isAnalyzing else {
            return
        }
        isAnalyzing = true
        analysisFailed = false
        rebuild()
        let text = editedText ?? submission.text
        Task {
            do {
                let veteran = try await veteransRepository.originalVeterans().first { return $0.id == submission.veteranId }
                analysis = try await analysisRepository.analyze(analysisInput(veteran: veteran ?? Veteran(), text: text))
            } catch {
                analysisFailed = true
            }
            isAnalyzing = false
            rebuild()
        }
    }

    private func analysisInput(veteran: Veteran, text: String) -> SubmissionAnalysisInput {
        return SubmissionAnalysisInput(
            veteranName: veteran.name.isBlank ? veteranName : veteran.name,
            years: veteran.years,
            birthDate: veteran.birthDate,
            deathDate: veteran.deathDate,
            biography: veteran.allInfo.isBlank ? veteran.baseInfo : veteran.allInfo,
            rewards: RewardsParser.parse(veteran.rewards).map { return L10n.string($0.reward.nameResource) },
            cardMaterials: veteran.veteransInfo.filter { return !$0.contains(VeteranInfoFormat.linkMarker) },
            submissionText: text,
            photoUrls: photoUrls.filter { return !deselectedUrls.contains($0) }
        )
    }

    private func runDecision(_ decision: @escaping () async throws -> Void) {
        guard !isProcessing else {
            return
        }
        isProcessing = true
        failure = nil
        rebuild()
        Task {
            do {
                try await decision()
                isFinished = true
            } catch ModerationError.permissionDenied {
                failure = .noPermission
            } catch {
                failure = .network
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
            failure: failure,
            isFinished: isFinished,
            analysis: analysis,
            isAnalyzing: isAnalyzing,
            analysisFailed: analysisFailed
        ))
    }
}
