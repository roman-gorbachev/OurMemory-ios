import Foundation

nonisolated struct Feedback: Hashable, Identifiable, Sendable {
    let id: String
    let type: FeedbackType
    let text: String
    let contact: String
    let veteranId: String
    let isReviewed: Bool
    let createdAt: Int64
    var reply = ""
    var reviewedAt: Int64 = 0
}
