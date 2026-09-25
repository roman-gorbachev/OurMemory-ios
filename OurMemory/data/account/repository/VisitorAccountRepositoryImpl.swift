import Combine
import Foundation

final class VisitorAccountRepositoryImpl: VisitorAccountRepository {
    private let accountDataSource: GoogleAccountDataSource
    private let favoritesLocalDataSource: FavoritesLocalDataSource
    private let favoritesRemoteDataSource: FavoritesRemoteDataSource

    init(
        accountDataSource: GoogleAccountDataSource,
        favoritesLocalDataSource: FavoritesLocalDataSource,
        favoritesRemoteDataSource: FavoritesRemoteDataSource
    ) {
        self.accountDataSource = accountDataSource
        self.favoritesLocalDataSource = favoritesLocalDataSource
        self.favoritesRemoteDataSource = favoritesRemoteDataSource
    }

    func accountPublisher() -> AnyPublisher<VisitorAccount?, Never> {
        return accountDataSource.accountPublisher()
    }

    func signInWithGoogle(idToken: String, accessToken: String) async -> GoogleSignInResult {
        guard let account = await accountDataSource.signInWithGoogle(idToken: idToken, accessToken: accessToken) else {
            return .failed
        }
        try? await favoritesRemoteDataSource.addAll(uid: account.uid, veteranIds: favoritesLocalDataSource.favorites())
        return .success
    }

    func signOut() {
        accountDataSource.signOut()
    }
}
