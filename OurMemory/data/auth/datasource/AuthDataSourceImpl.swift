import Combine
import FirebaseAuth
import FirebaseDatabase
import Foundation

final class AuthDataSourceImpl: AuthDataSource {
    private static let wrongCredentialCodes: Set<AuthErrorCode> = [
        .wrongPassword, .invalidCredential, .userNotFound, .invalidEmail, .userDisabled
    ]

    private let auth: Auth
    private let root: DatabaseReference

    init(auth: Auth, root: DatabaseReference) {
        self.auth = auth
        self.root = root
    }

    func userPublisher() -> AnyPublisher<AuthUser?, Never> {
        return auth.userPublisher()
            .map { user in return user.map { return $0.toAuthUser() } }
            .eraseToAnyPublisher()
    }

    func isAdminPublisher(uid: String) -> AnyPublisher<Bool, Never> {
        return adminReference(uid: uid)
            .valuePublisher()
            .map { return $0.exists() }
            .replaceError(with: false)
            .eraseToAnyPublisher()
    }

    func isSuperAdminPublisher(uid: String) -> AnyPublisher<Bool, Never> {
        return root.child(DatabaseNodes.superAdmins).child(uid)
            .valuePublisher()
            .map { return $0.exists() }
            .replaceError(with: false)
            .eraseToAnyPublisher()
    }

    func isAdmin(uid: String) async throws -> Bool {
        return try await adminReference(uid: uid).getData().exists()
    }

    func signIn(email: String, password: String) async throws -> AuthUser? {
        do {
            return try await auth.signIn(withEmail: email, password: password).user.toAuthUser()
        } catch let error as NSError {
            if let code = AuthErrorCode(rawValue: error.code), Self.wrongCredentialCodes.contains(code) {
                return nil
            }
            throw error
        }
    }

    func signOut() {
        try? auth.signOut()
    }

    var currentUid: String? {
        return auth.currentUser?.uid
    }

    private func adminReference(uid: String) -> DatabaseReference {
        return root.child(DatabaseNodes.admins).child(uid)
    }
}
