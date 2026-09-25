import Foundation

nonisolated enum SignInResult: Hashable, Sendable {
    case admin
    case notAdmin
    case wrongCredentials
}
