import Foundation

nonisolated enum FeedbackType: String, CaseIterable, Hashable, Sendable {
    case dataError = "DATA_ERROR"
    case suggestion = "SUGGESTION"
    case other = "OTHER"
}
