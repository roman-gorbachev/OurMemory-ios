import Foundation

enum AdminsUserAction {
    case add(email: String)
    case remove(uid: String)
    case addStatusShown
}
