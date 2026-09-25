import Foundation

enum FeedbackListUserAction {
    case markReviewed(feedbackId: String)
    case reply(feedbackId: String, text: String)
}
