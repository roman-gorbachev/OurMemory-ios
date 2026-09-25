import Foundation

enum FeedbackUserAction {
    case typeChanged(FeedbackType)
    case textChanged(String)
    case contactChanged(String)
    case send
}
