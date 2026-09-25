import Foundation

nonisolated enum AccountKeys {
    private static let dot = "."
    private static let keyDot = ","

    static func forEmail(_ email: String) -> String {
        return email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased().replacingOccurrences(of: dot, with: keyDot)
    }
}
