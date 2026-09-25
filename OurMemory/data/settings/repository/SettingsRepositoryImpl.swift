import Combine
import Foundation

final class SettingsRepositoryImpl: SettingsRepository {
    private static let notificationsAskedKey = "notifications_asked"
    private static let introSeenKey = "intro_seen"
    private static let themeModeKey = "theme_mode"
    private static let textScaleKey = "text_scale"
    private static let languageKey = "app_language"
    private static let victoryDayReminderKey = "victory_day_reminder"
    private static let favoriteRemindersKey = "favorite_reminders"

    private let preferences: PreferencesStore

    init(preferences: PreferencesStore) {
        self.preferences = preferences
    }

    func notificationsAskedPublisher() -> AnyPublisher<Bool, Never> {
        return preferences.publisher { return $0.bool(forKey: Self.notificationsAskedKey) }
    }

    func markNotificationsAsked() {
        preferences.edit { $0.set(true, forKey: Self.notificationsAskedKey) }
    }

    func introSeenPublisher() -> AnyPublisher<Bool, Never> {
        return preferences.publisher { return $0.bool(forKey: Self.introSeenKey) }
    }

    func markIntroSeen() {
        preferences.edit { $0.set(true, forKey: Self.introSeenKey) }
    }

    func settingsPublisher() -> AnyPublisher<AppSettings, Never> {
        return preferences.publisher { defaults in
            return AppSettings(
                themeMode: defaults.string(forKey: Self.themeModeKey).flatMap(ThemeMode.init(rawValue:)) ?? .system,
                textScale: defaults.string(forKey: Self.textScaleKey).flatMap(TextScale.init(rawValue:)) ?? .normal,
                language: Self.language(in: defaults),
                victoryDayReminder: defaults.object(forKey: Self.victoryDayReminderKey) as? Bool ?? true,
                favoriteReminders: defaults.object(forKey: Self.favoriteRemindersKey) as? Bool ?? true
            )
        }
    }

    func setThemeMode(_ mode: ThemeMode) {
        preferences.edit { $0.set(mode.rawValue, forKey: Self.themeModeKey) }
    }

    func setTextScale(_ scale: TextScale) {
        preferences.edit { $0.set(scale.rawValue, forKey: Self.textScaleKey) }
    }

    func currentLanguage() -> AppLanguage {
        return preferences.read(Self.language(in:))
    }

    func setLanguage(_ language: AppLanguage) {
        preferences.edit { $0.set(language.rawValue, forKey: Self.languageKey) }
    }

    func setVictoryDayReminder(isEnabled: Bool) {
        preferences.edit { $0.set(isEnabled, forKey: Self.victoryDayReminderKey) }
    }

    func setFavoriteReminders(isEnabled: Bool) {
        preferences.edit { $0.set(isEnabled, forKey: Self.favoriteRemindersKey) }
    }

    nonisolated private static func language(in defaults: UserDefaults) -> AppLanguage {
        return defaults.string(forKey: languageKey).flatMap(AppLanguage.init(rawValue:)) ?? AppLanguage.preferredBySystem
    }
}
