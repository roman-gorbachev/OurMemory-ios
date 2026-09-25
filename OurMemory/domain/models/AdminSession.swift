import Foundation

nonisolated struct AdminSession: Hashable, Sendable {
    var uid = ""
    var email = ""
    var isAdmin = false
    var isSuperAdmin = false
}
