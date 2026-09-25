import Combine
import Foundation

@Observable
final class RootViewModel {
    private(set) var settings = AppSettings()
    private(set) var isAdmin = false

    @ObservationIgnored private let settingsRepository: SettingsRepository
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()

    init(settingsRepository: SettingsRepository, authRepository: AuthRepository) {
        self.settingsRepository = settingsRepository
        observeRootUiState(authRepository: authRepository)
    }

    func setLanguage(_ language: AppLanguage) {
        settingsRepository.setLanguage(language)
    }

    private func observeRootUiState(authRepository: AuthRepository) {
        settingsRepository.settingsPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] settings in
                L10n.language = settings.language
                self?.settings = settings
            }
            .store(in: &cancellables)
        authRepository.sessionPublisher()
            .map(\.isAdmin)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.isAdmin = $0 }
            .store(in: &cancellables)
    }
}
