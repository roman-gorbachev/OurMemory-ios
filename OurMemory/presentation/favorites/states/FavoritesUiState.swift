import Foundation

enum FavoritesUiState {
    case loading
    case success(data: [FavoriteVeteranUi])
    case error
}
