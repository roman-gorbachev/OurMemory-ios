import Combine
import Foundation

protocol GoogleAccountDataSource: AnyObject {
    func accountPublisher() -> AnyPublisher<VisitorAccount?, Never>
    func currentAccount() -> VisitorAccount?
    func signInWithGoogle(idToken: String, accessToken: String) async -> VisitorAccount?
    func signOut()
}
