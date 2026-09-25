import Foundation

enum SubmissionReviewUserAction {
    case textChanged(String)
    case replyChanged(String)
    case photoToggled(String)
    case approve
    case reject
}
