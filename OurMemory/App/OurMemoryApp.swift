import SwiftUI

@main
struct OurMemoryApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            Text("app_name")
        }
    }
}
