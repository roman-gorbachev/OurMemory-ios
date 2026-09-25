import Foundation

nonisolated struct AdminAccount: Hashable, Identifiable, Sendable {
    let uid: String
    let email: String
    let isSuperAdmin: Bool

    var id: String {
        return uid
    }
}
