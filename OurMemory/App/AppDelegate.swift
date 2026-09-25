import FirebaseCore
import FirebaseDatabase
import UIKit
import UserNotifications
import YandexMapsMobile

final class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    private(set) var container: AppDIContainer?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        YMKMapKit.setApiKey(AppConfig.mapKitApiKey)
        YMKMapKit.sharedInstance().onStart()
        UNUserNotificationCenter.current().delegate = self
        guard FirebaseEnvironment.hasConfiguration else {
            return true
        }
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        let container = AppDIContainer()
        self.container = container
        container.startBackgroundWork()
        Task {
            let settings = await container.settingsRepository.settingsPublisher().values.first { _ in return true }
            await container.reminderScheduler.setVictoryDayReminder(isEnabled: settings?.victoryDayReminder ?? true)
        }
        return true
    }

    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        let veteranId = response.notification.request.content.userInfo[ReminderNotifications.veteranIdKey] as? String
        await MainActor.run {
            if let veteranId, let url = VeteranLink.url(forVeteranId: veteranId) {
                _ = DeepLinkCenter.shared.handle(url)
            }
        }
    }

    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        return [.banner, .sound]
    }
}
