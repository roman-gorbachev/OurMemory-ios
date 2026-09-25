import Foundation

nonisolated enum RequestStatus: Hashable, Sendable {
    case inReview
    case approved
    case rejected
    case reviewed
}
