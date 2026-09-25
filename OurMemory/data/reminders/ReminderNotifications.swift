import Foundation
import UserNotifications

nonisolated enum ReminderNotifications {
    static let victoryDayId = "victory_day_reminder"
    static let anniversaryIdPrefix = "anniversary_"
    static let veteranIdKey = "veteranId"

    static func isAuthorized(_ center: UNUserNotificationCenter) async -> Bool {
        let status = await center.notificationSettings().authorizationStatus
        return status == .authorized || status == .provisional || status == .ephemeral
    }

    static func requestAuthorization() async -> Bool {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        return (try? await UNUserNotificationCenter.current().requestAuthorization(options: options)) ?? false
    }
}
