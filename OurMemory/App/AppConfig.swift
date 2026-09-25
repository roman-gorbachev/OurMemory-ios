import Foundation

enum AppConfig {
    private static let mapKitApiKeyName = "MapKitApiKey"

    static var mapKitApiKey: String {
        return Bundle.main.object(forInfoDictionaryKey: mapKitApiKeyName) as? String ?? ""
    }
}
