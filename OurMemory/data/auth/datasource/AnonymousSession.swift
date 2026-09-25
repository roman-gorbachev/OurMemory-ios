import FirebaseAuth
import Foundation

final class AnonymousSession {
    private let auth: Auth

    init(auth: Auth) {
        self.auth = auth
    }

    func ensureSignedIn() async throws -> String {
        if let user = auth.currentUser {
            return user.uid
        }
        return try await auth.signInAnonymously().user.uid
    }
}
