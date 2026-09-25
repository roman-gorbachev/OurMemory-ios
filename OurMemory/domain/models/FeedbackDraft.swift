import Foundation

nonisolated struct FeedbackDraft: Hashable, Sendable {
    let type: FeedbackType
    let text: String
    let contact: String
    let veteranId: String
}
