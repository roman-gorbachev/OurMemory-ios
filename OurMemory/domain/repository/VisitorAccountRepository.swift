import Combine
import Foundation

protocol VisitorAccountRepository: AnyObject {
    func accountPublisher() -> AnyPublisher<VisitorAccount?, Never>
    func signInWithGoogle(idToken: String, accessToken: String) async -> GoogleSignInResult
    func signOut()
}
