import Combine
import FirebaseAuth
import Foundation

final class GoogleAccountDataSourceImpl: GoogleAccountDataSource {
    private static let googleProviderId = "google.com"

    private let auth: Auth
    private let accountVersion = CurrentValueSubject<Int, Never>(0)

    init(auth: Auth) {
        self.auth = auth
    }

    func accountPublisher() -> AnyPublisher<VisitorAccount?, Never> {
        return auth.userPublisher()
            .combineLatest(accountVersion)
            .map { [weak self] user, _ in return user.flatMap { return self?.visitorAccount(from: $0) } }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    func currentAccount() -> VisitorAccount? {
        return auth.currentUser.flatMap { return visitorAccount(from: $0) }
    }

    func signInWithGoogle(idToken: String, accessToken: String) async -> VisitorAccount? {
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        let user: User?
        do {
            if let current = auth.currentUser, current.isAnonymous {
                user = try await current.link(with: credential).user
            } else {
                user = try await auth.signIn(with: credential).user
            }
        } catch let error as NSError where error.code == AuthErrorCode.credentialAlreadyInUse.rawValue {
            let updated = error.userInfo[AuthErrorUserInfoUpdatedCredentialKey] as? AuthCredential ?? credential
            user = try? await auth.signIn(with: updated).user
        } catch {
            user = nil
        }
        accountVersion.send(accountVersion.value + 1)
        return user.flatMap { return visitorAccount(from: $0) }
    }

    func signOut() {
        try? auth.signOut()
        accountVersion.send(accountVersion.value + 1)
    }

    private func visitorAccount(from user: User) -> VisitorAccount? {
        guard let google = user.providerData.first(where: { return $0.providerID == Self.googleProviderId }) else {
            return nil
        }
        let name = user.displayName ?? ""
        let email = user.email ?? ""
        return VisitorAccount(
            uid: user.uid,
            name: name.isEmpty ? google.displayName ?? "" : name,
            email: email.isEmpty ? google.email ?? "" : email,
            photoUrl: (user.photoURL ?? google.photoURL)?.absoluteString ?? ""
        )
    }
}
