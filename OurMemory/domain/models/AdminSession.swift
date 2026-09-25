import Foundation

nonisolated struct AdminSession: Hashable, Sendable {
    var email = ""
    var isAdmin = false
}
