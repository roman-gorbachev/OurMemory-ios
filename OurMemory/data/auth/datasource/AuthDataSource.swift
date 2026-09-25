import Combine
import Foundation

protocol AuthDataSource: AnyObject {
    func userPublisher() -> AnyPublisher<AuthUser?, Never>
    func isAdminPublisher(uid: String) -> AnyPublisher<Bool, Never>
    func isAdmin(uid: String) async throws -> Bool
    func signIn(email: String, password: String) async throws -> AuthUser?
    func signOut()
    var currentUid: String? { get }
}
