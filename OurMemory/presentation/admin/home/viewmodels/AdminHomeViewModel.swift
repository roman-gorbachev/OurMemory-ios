import Combine
import Foundation

@Observable
final class AdminHomeViewModel {
    private(set) var adminHomeUiData = AdminHomeUiData()

    @ObservationIgnored private let authRepository: AuthRepository
    @ObservationIgnored private let veteransRepository: VeteransRepository
    @ObservationIgnored private let burialsRepository: BurialsRepository
    @ObservationIgnored private let toursRepository: ToursRepository
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()

    init(
        authRepository: AuthRepository,
        feedbackRepository: FeedbackRepository,
        moderationRepository: ModerationRepository,
        veteransRepository: VeteransRepository,
        burialsRepository: BurialsRepository,
        toursRepository: ToursRepository
    ) {
        self.authRepository = authRepository
        self.veteransRepository = veteransRepository
        self.burialsRepository = burialsRepository
        self.toursRepository = toursRepository
        observeAdminHomeUiState(feedbackRepository: feedbackRepository, moderationRepository: moderationRepository)
    }

    func loadContentCounts() async {
        adminHomeUiData.veteransCount = (try? await veteransRepository.allVeterans().count) ?? 0
        adminHomeUiData.burialsCount = (try? await burialsRepository.allBurials().count) ?? 0
        adminHomeUiData.toursCount = (try? await toursRepository.allTours().count) ?? 0
    }

    func signOut() {
        authRepository.signOut()
    }

    private func observeAdminHomeUiState(feedbackRepository: FeedbackRepository, moderationRepository: ModerationRepository) {
        authRepository.sessionPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.adminHomeUiData.email = $0.email }
            .store(in: &cancellables)
        moderationRepository.submissionsPublisher()
            .map { return $0.filter { return $0.status == .pending }.count }
            .replaceError(with: 0)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.adminHomeUiData.pendingSubmissionsCount = $0 }
            .store(in: &cancellables)
        feedbackRepository.feedbackPublisher()
            .map { return $0.filter { return !$0.isReviewed }.count }
            .replaceError(with: 0)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.adminHomeUiData.newFeedbackCount = $0 }
            .store(in: &cancellables)
    }
}
