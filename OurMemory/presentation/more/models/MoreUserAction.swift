import Foundation

enum MoreUserAction {
    case themeModeChanged(ThemeMode)
    case textScaleChanged(TextScale)
    case languageChanged(AppLanguage)
    case victoryDayReminderChanged(Bool)
    case favoriteRemindersChanged(Bool)
    case googleSignInStarted
    case googleTokensReceived(idToken: String, accessToken: String)
    case googleSignInFailed(SignInStatus)
    case signOut
}
