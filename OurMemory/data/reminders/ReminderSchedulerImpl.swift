import Foundation
import UserNotifications

final class ReminderSchedulerImpl: ReminderScheduler {
    private static let victoryMonth = 5
    private static let victoryDay = 9
    private static let reminderHour = 10

    private let center: UNUserNotificationCenter

    init(center: UNUserNotificationCenter) {
        self.center = center
    }

    func setVictoryDayReminder(isEnabled: Bool) async {
        center.removePendingNotificationRequests(withIdentifiers: [ReminderNotifications.victoryDayId])
        guard isEnabled else {
            return
        }
        let content = UNMutableNotificationContent()
        content.title = L10n.string("victory_day")
        content.body = L10n.string("remember_heroes_msg")
        content.sound = .default
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: DateComponents(month: Self.victoryMonth, day: Self.victoryDay, hour: Self.reminderHour),
            repeats: true
        )
        let request = UNNotificationRequest(identifier: ReminderNotifications.victoryDayId, content: content, trigger: trigger)
        try? await center.add(request)
    }
}
