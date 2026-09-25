import GoogleSignIn
import SwiftUI
import YandexMapsMobile

@main
struct OurMemoryApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            Group {
                if let container = appDelegate.container {
                    RootView(container: container)
                } else {
                    ConfigurationErrorView()
                }
            }
            .onOpenURL { url in
                if !GIDSignIn.sharedInstance.handle(url) {
                    _ = DeepLinkCenter.shared.handle(url)
                }
            }
            .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { activity in
                if let url = activity.webpageURL {
                    _ = DeepLinkCenter.shared.handle(url)
                }
            }
        }
        .onChange(of: scenePhase) { _, phase in
            switch phase {
            case .active:
                YMKMapKit.sharedInstance().onStart()
            case .background:
                YMKMapKit.sharedInstance().onStop()
            default:
                break
            }
        }
    }
}
