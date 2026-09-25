import Combine
import Foundation

final class AuthRepositoryImpl: AuthRepository {
    private let dataSource: AuthDataSource

    init(dataSource: AuthDataSource) {
        self.dataSource = dataSource
    }

    func sessionPublisher() -> AnyPublisher<AdminSession, Never> {
        let dataSource = dataSource
        return dataSource.userPublisher()
            .map { user -> AnyPublisher<AdminSession, Never> in
                guard let user, !user.isAnonymous else {
                    return Just(AdminSession()).eraseToAnyPublisher()
                }
                return dataSource.isAdminPublisher(uid: user.uid)
                    .map { return AdminSession(email: user.email, isAdmin: $0) }
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
}
