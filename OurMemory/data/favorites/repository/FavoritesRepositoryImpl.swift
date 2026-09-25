import Combine
import Foundation

final class FavoritesRepositoryImpl: FavoritesRepository {
    private let localDataSource: FavoritesLocalDataSource
    private let remoteDataSource: FavoritesRemoteDataSource
    private let accountDataSource: GoogleAccountDataSource
    private let favoritesSubject = CurrentValueSubject<Set<String>, Never>([])
    private var cancellable: AnyCancellable?

    init(
        localDataSource: FavoritesLocalDataSource,
        remoteDataSource: FavoritesRemoteDataSource,
        accountDataSource: GoogleAccountDataSource
    ) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
        self.accountDataSource = accountDataSource
        cancellable = observeFavorites().sink { [weak self] favorites in
            self?.favoritesSubject.send(favorites)
        }
    }

    func favoritesPublisher() -> AnyPublisher<Set<String>, Never> {
        return favoritesSubject.removeDuplicates().eraseToAnyPublisher()
    }

    func toggle(veteranId: String) async throws {
        let isFavorite = !favoritesSubject.value.contains(veteranId)
        localDataSource.set(veteranId: veteranId, isFavorite: isFavorite)
        if let uid = accountDataSource.currentAccount()?.uid {
            try await remoteDataSource.set(uid: uid, veteranId: veteranId, isFavorite: isFavorite)
        }
    }

    private func observeFavorites() -> AnyPublisher<Set<String>, Never> {
        let local = localDataSource.favoritesPublisher()
        let remote = remoteDataSource
        return accountDataSource.accountPublisher()
            .map { return $0?.uid }
            .removeDuplicates()
            .map { uid -> AnyPublisher<Set<String>, Never> in
                guard let uid else {
                    return local
                }
                return remote.favoritesPublisher(uid: uid)
                    .catch { _ in return local }
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
}
