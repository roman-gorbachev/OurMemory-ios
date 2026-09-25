import FirebaseCore
import Foundation

enum FirebaseEnvironment {
    private static let configFileName = "GoogleService-Info"
    private static let configFileExtension = "plist"

    static var hasConfiguration: Bool {
        return Bundle.main.path(forResource: configFileName, ofType: configFileExtension) != nil
    }

    static var isConfigured: Bool {
        return FirebaseApp.app() != nil
    }
}
