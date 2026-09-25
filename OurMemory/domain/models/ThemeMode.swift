import Foundation

nonisolated enum ThemeMode: String, CaseIterable, Hashable, Sendable {
    case system = "SYSTEM"
    case light = "LIGHT"
    case dark = "DARK"
}
