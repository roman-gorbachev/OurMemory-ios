import Combine
import Foundation

protocol SettingsRepository: AnyObject {
    func notificationsAskedPublisher() -> AnyPublisher<Bool, Never>
    func markNotificationsAsked()
    func settingsPublisher() -> AnyPublisher<AppSettings, Never>
    func setThemeMode(_ mode: ThemeMode)
    func setTextScale(_ scale: TextScale)
    func setLanguage(_ language: AppLanguage)
    func setVictoryDayReminder(isEnabled: Bool)
    func setFavoriteReminders(isEnabled: Bool)
}
