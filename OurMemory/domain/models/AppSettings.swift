import Foundation

nonisolated struct AppSettings: Hashable, Sendable {
    var themeMode = ThemeMode.system
    var textScale = TextScale.normal
    var language = AppLanguage.russian
    var victoryDayReminder = true
    var favoriteReminders = true
}
