import FirebaseDatabase
import Foundation

final class AccountIndexDataSourceImpl: AccountIndexDataSource {
    private static let uidField = "uid"
    private static let emailField = "email"

    private let root: DatabaseReference

    init(root: DatabaseReference) {
        self.root = root
    }

    func register(uid: String, email: String) async throws {
        try await root.child(DatabaseNodes.accounts)
            .child(AccountKeys.forEmail(email))
            .setValue([Self.uidField: uid, Self.emailField: email])
    }
}
