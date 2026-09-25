import Combine
import Foundation

@Observable
final class FavoritesViewModel {
    private(set) var favoritesUiState = FavoritesUiState.loading

    @ObservationIgnored private let veteransRepository: VeteransRepository
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()

    init(favoritesRepository: FavoritesRepository, veteransRepository: VeteransRepository) {
        self.veteransRepository = veteransRepository
        observeFavoritesUiState(favoritesRepository: favoritesRepository)
    }

    private func observeFavoritesUiState(favoritesRepository: FavoritesRepository) {
        favoritesRepository.favoritesPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] favorites in
                Task { await self?.rebuild(favorites: favorites) }
            }
            .store(in: &cancellables)
    }

    private func rebuild(favorites: Set<String>) async {
        do {
            let veterans = try await veteransRepository.allVeterans()
            favoritesUiState = .success(data: veterans
                .filter { return favorites.contains($0.id) }
                .map { return FavoriteVeteranUi(id: $0.id, name: $0.name, years: $0.years, portrait: $0.portrait) })
        } catch {
            favoritesUiState = .error
        }
    }
}
