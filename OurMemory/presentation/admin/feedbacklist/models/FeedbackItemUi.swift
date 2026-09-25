import Foundation

struct FeedbackItemUi: Hashable, Identifiable {
    let id: String
    let type: FeedbackType
    let text: String
    let contact: String
    let veteranId: String
    let veteranName: String
    let isReviewed: Bool
    let date: String
    let reply: String
}
