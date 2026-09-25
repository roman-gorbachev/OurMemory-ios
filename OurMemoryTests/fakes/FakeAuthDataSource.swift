import Combine
import Foundation
@testable import OurMemory

final class FakeAuthDataSource: AuthDataSource {
    static let password = "secret"

    let user = CurrentValueSubject<AuthUser?, Never>(nil)
    let admins: CurrentValueSubject<Set<String>, Never>
    let superAdmins = CurrentValueSubject<Set<String>, Never>([])
    private let accounts: [String: AuthUser]

    init(accounts: [String: AuthUser], adminUids: Set<String>) {
        self.accounts = accounts
        admins = CurrentValueSubject(adminUids)
    }

    func userPublisher() -> AnyPublisher<AuthUser?, Never> {
        return user.eraseToAnyPublisher()
    }

    func isAdminPublisher(uid: String) -> AnyPublisher<Bool, Never> {
        return admins.map { return $0.contains(uid) }.eraseToAnyPublisher()
    }

    func isSuperAdminPublisher(uid: String) -> AnyPublisher<Bool, Never> {
        return superAdmins.map { return $0.contains(uid) }.eraseToAnyPublisher()
    }

    func isAdmin(uid: String) async throws -> Bool {
        return admins.value.contains(uid)
    }

    func signIn(email: String, password: String) async throws -> AuthUser? {
        guard password == Self.password, let account = accounts[email] else {
            return nil
        }
        user.send(account)
        return account
    }

    func signOut() {
        user.send(nil)
    }

    var currentUid: String? {
        return user.value?.uid
    }
}
