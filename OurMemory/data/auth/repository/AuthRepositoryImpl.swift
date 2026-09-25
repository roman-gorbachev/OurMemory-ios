import Combine
import Foundation

final class AuthRepositoryImpl: AuthRepository {
    private let dataSource: AuthDataSource
    private let accountIndex: AccountIndexDataSource

    init(dataSource: AuthDataSource, accountIndex: AccountIndexDataSource) {
        self.dataSource = dataSource
        self.accountIndex = accountIndex
    }

    func sessionPublisher() -> AnyPublisher<AdminSession, Never> {
        let dataSource = dataSource
        return dataSource.userPublisher()
            .map { [weak self] user -> AnyPublisher<AdminSession, Never> in
                guard let user, !user.isAnonymous else {
                    return Just(AdminSession()).eraseToAnyPublisher()
                }
                self?.registerAccount(user)
                return dataSource.isAdminPublisher(uid: user.uid)
                    .combineLatest(dataSource.isSuperAdminPublisher(uid: user.uid))
                    .map { isAdmin, isSuperAdmin in
                        return AdminSession(uid: user.uid, email: user.email, isAdmin: isAdmin, isSuperAdmin: isSuperAdmin)
                    }
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    func signIn(email: String, password: String) async throws -> SignInResult {
        guard let user = try await dataSource.signIn(email: email, password: password) else {
            return .wrongCredentials
        }
        registerAccount(user)
        if try await dataSource.isAdmin(uid: user.uid) {
            return .admin
        }
        dataSource.signOut()
        return .notAdmin
    }

    func signOut() {
        dataSource.signOut()
    }

    var currentUid: String? {
        return dataSource.currentUid
    }

    private func registerAccount(_ user: AuthUser) {
        guard !user.isAnonymous, !user.email.isBlank else {
            return
        }
        let accountIndex = accountIndex
        Task { try? await accountIndex.register(uid: user.uid, email: user.email) }
    }
}
