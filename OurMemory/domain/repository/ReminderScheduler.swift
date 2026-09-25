import Foundation

protocol ReminderScheduler: AnyObject {
    func setVictoryDayReminder(isEnabled: Bool) async
}
