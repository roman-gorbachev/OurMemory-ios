import Combine
import Foundation

final class VisitorAccountRepositoryImpl: VisitorAccountRepository {
    private let accountDataSource: GoogleAccountDataSource
    private let favoritesLocalDataSource: FavoritesLocalDataSource
    private let favoritesRemoteDataSource: FavoritesRemoteDataSource
    private let accountIndex: AccountIndexDataSource

    init(
        accountDataSource: GoogleAccountDataSource,
        favoritesLocalDataSource: FavoritesLocalDataSource,
        favoritesRemoteDataSource: FavoritesRemoteDataSource,
        accountIndex: AccountIndexDataSource
    ) {
        self.accountDataSource = accountDataSource
        self.favoritesLocalDataSource = favoritesLocalDataSource
        self.favoritesRemoteDataSource = favoritesRemoteDataSource
        self.accountIndex = accountIndex
    }

    func accountPublisher() -> AnyPublisher<VisitorAccount?, Never> {
        return accountDataSource.accountPublisher()
    }

    func signInWithGoogle(idToken: String, accessToken: String) async -> GoogleSignInResult {
        guard let account = await accountDataSource.signInWithGoogle(idToken: idToken, accessToken: accessToken) else {
            return .failed
        }
        if !account.email.isBlank {
            try? await accountIndex.register(uid: account.uid, email: account.email)
        }
        try? await favoritesRemoteDataSource.addAll(uid: account.uid, veteranIds: favoritesLocalDataSource.favorites())
        return .success
    }

    func signOut() {
        accountDataSource.signOut()
    }
}
