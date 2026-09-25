import Foundation

enum AdminsUiState {
    case loading
    case success(data: [AdminItemUi])
    case error
}
