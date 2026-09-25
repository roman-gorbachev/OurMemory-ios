import Foundation

nonisolated enum PhotoCheckResult: Hashable, Sendable {
    case allowed
    case blocked
    case unreadable
}
