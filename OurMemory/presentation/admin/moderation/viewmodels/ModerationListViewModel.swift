import Combine
import Foundation

@Observable
final class ModerationListViewModel {
    private(set) var moderationListUiState = ModerationListUiState.loading

    @ObservationIgnored private let veteransRepository: VeteransRepository
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    @ObservationIgnored private var names: [String: String] = [:]
    @ObservationIgnored private var submissions: [Submission]?

    init(moderationRepository: ModerationRepository, veteransRepository: VeteransRepository) {
        self.veteransRepository = veteransRepository
        observeModerationListUiState(moderationRepository: moderationRepository)
    }

    func loadNames() async {
        names = await VeteranNamesLoader.names(from: veteransRepository)
        rebuild()
    }

    private func observeModerationListUiState(moderationRepository: ModerationRepository) {
        moderationRepository.submissionsPublisher()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure = completion {
                        self?.moderationListUiState = .error
                    }
                },
                receiveValue: { [weak self] submissions in
                    self?.submissions = submissions
                    self?.rebuild()
                }
            )
            .store(in: &cancellables)
    }

    private func rebuild() {
        guard let submissions else {
            return
        }
        moderationListUiState = .success(data: submissions.map { submission in
            let name = names[submission.veteranId] ?? ""
            return SubmissionItemUi(
                id: submission.id,
                veteranName: name.isBlank ? submission.veteranId : name,
                text: submission.text,
                photoCount: submission.photoPaths.count,
                status: submission.status,
                date: DisplayDate.text(fromMilliseconds: submission.createdAt)
            )
        })
    }
}
