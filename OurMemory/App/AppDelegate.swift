import FirebaseCore
import UIKit
import YandexMapsMobile

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        if Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil {
            FirebaseApp.configure()
        }
        YMKMapKit.setApiKey(Bundle.main.object(forInfoDictionaryKey: "MapKitApiKey") as? String ?? "")
        YMKMapKit.sharedInstance().onStart()
        return true
    }
}
