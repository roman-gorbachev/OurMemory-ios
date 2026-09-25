import Combine
import Foundation

protocol AuthRepository: AnyObject {
    func sessionPublisher() -> AnyPublisher<AdminSession, Never>
    func signIn(email: String, password: String) async throws -> SignInResult
    func signOut()
    var currentUid: String? { get }
}
