import Foundation

nonisolated enum ModerationStatus: Hashable, Sendable {
    case pending
    case approved
    case rejected
}
