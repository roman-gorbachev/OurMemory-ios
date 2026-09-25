import Foundation

struct AdminItemUi: Hashable, Identifiable {
    let uid: String
    let email: String
    let isSuperAdmin: Bool
    let isCurrentUser: Bool

    var id: String {
        return uid
    }

    var canRemove: Bool {
        return !isSuperAdmin && !isCurrentUser
    }
}
