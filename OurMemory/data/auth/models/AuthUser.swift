import Foundation

nonisolated struct AuthUser: Hashable, Sendable {
    let uid: String
    let email: String
    let isAnonymous: Bool
}
