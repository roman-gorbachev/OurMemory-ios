import FirebaseAuth
import Foundation

extension User {
    func toAuthUser() -> AuthUser {
        return AuthUser(uid: uid, email: email ?? "", isAnonymous: isAnonymous)
    }
}
