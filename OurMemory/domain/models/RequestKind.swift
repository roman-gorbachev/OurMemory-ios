import Foundation

nonisolated enum RequestKind: Hashable, Sendable {
    case submission
    case feedback
}
