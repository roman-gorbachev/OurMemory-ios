import Combine
import FirebaseDatabase
import Foundation

final class AdminsDataSourceImpl: AdminsDataSource {
    private static let uidField = "uid"
    private static let emailField = "email"

    private let root: DatabaseReference
    private let admins: DatabaseReference

    init(root: DatabaseReference) {
        self.root = root
        admins = root.child(DatabaseNodes.admins)
    }

    func adminUidsPublisher() -> AnyPublisher<Set<String>, Error> {
        return admins.valuePublisher()
            .map { return Set($0.childSnapshots.map(\.key)) }
            .eraseToAnyPublisher()
    }

    func superAdminUidsPublisher() -> AnyPublisher<Set<String>, Error> {
        return root.child(DatabaseNodes.superAdmins).valuePublisher()
            .map { return Set($0.childSnapshots.map(\.key)) }
            .eraseToAnyPublisher()
    }

    func accountEmailsPublisher() -> AnyPublisher<[String: String], Error> {
        return root.child(DatabaseNodes.accounts).valuePublisher()
            .map { snapshot in
                var emails: [String: String] = [:]
                for account in snapshot.childSnapshots {
                    if let uid = account.childSnapshot(forPath: Self.uidField).value as? String {
                        emails[uid] = account.childSnapshot(forPath: Self.emailField).value as? String ?? ""
                    }
                }
                return emails
            }
            .eraseToAnyPublisher()
    }

    func findUid(email: String) async throws -> String? {
        let snapshot = try await root.child(DatabaseNodes.accounts)
            .child(AccountKeys.forEmail(email))
            .child(Self.uidField)
            .getData()
        return snapshot.value as? String
    }

    func isAdmin(uid: String) async throws -> Bool {
        return try await admins.child(uid).getData().exists()
    }

    func setAdmin(uid: String) async throws {
        try await admins.child(uid).setValue(true)
    }

    func removeAdmin(uid: String) async throws {
        try await admins.child(uid).removeValue()
    }
}
