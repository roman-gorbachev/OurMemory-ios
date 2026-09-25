import Combine
import Foundation

@Observable
final class MoreViewModel {
    private(set) var moreUiData = MoreUiData()

    @ObservationIgnored private let settingsRepository: SettingsRepository
    @ObservationIgnored private let reminderScheduler: ReminderScheduler
    @ObservationIgnored private let visitorAccountRepository: VisitorAccountRepository
    @ObservationIgnored private let signInStatus = CurrentValueSubject<SignInStatus, Never>(.idle)
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()

    init(
        settingsRepository: SettingsRepository,
        reminderScheduler: ReminderScheduler,
        visitorAccountRepository: VisitorAccountRepository,
        myRequestsRepository: MyRequestsRepository
    ) {
        self.settingsRepository = settingsRepository
        self.reminderScheduler = reminderScheduler
        self.visitorAccountRepository = visitorAccountRepository
        observeMoreUiState(myRequestsRepository: myRequestsRepository)
    }

    func onAction(_ action: MoreUserAction) {
        switch action {
        case .themeModeChanged(let mode):
            settingsRepository.setThemeMode(mode)
        case .textScaleChanged(let scale):
            settingsRepository.setTextScale(scale)
        case .languageChanged(let language):
            settingsRepository.setLanguage(language)
        case .victoryDayReminderChanged(let isEnabled):
            settingsRepository.setVictoryDayReminder(isEnabled: isEnabled)
            Task {
                if isEnabled {
                    _ = await ReminderNotifications.requestAuthorization()
                }
                await reminderScheduler.setVictoryDayReminder(isEnabled: isEnabled)
            }
        case .favoriteRemindersChanged(let isEnabled):
            settingsRepository.setFavoriteReminders(isEnabled: isEnabled)
            if isEnabled {
                Task { _ = await ReminderNotifications.requestAuthorization() }
            }
        case .googleSignInStarted:
            signInStatus.send(.inProgress)
        case .googleTokensReceived(let idToken, let accessToken):
            Task {
                let result = await visitorAccountRepository.signInWithGoogle(idToken: idToken, accessToken: accessToken)
                signInStatus.send(result == .success ? .idle : .failed)
            }
        case .googleSignInFailed(let status):
            signInStatus.send(status)
        case .signOut:
            signInStatus.send(.idle)
            visitorAccountRepository.signOut()
        }
    }

    private func observeMoreUiState(myRequestsRepository: MyRequestsRepository) {
        settingsRepository.settingsPublisher()
            .combineLatest(myRequestsRepository.unseenCountPublisher(), visitorAccountRepository.accountPublisher(), signInStatus)
            .map { settings, unseenCount, account, status in
                return MoreUiData(settings: settings, unseenRequestsCount: unseenCount, account: account, signInStatus: status)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.moreUiData = $0 }
            .store(in: &cancellables)
    }
}
