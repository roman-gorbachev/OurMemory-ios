import Foundation

nonisolated enum VeteranKeys {
    private static let prefix = "veteran"

    static func forId(_ veteranId: String) -> String {
        return "\(prefix)\(veteranId)"
    }
}
