import Foundation

enum AdminBurialsUiState {
    case loading
    case success(data: [AdminBurialItemUi])
    case error
}
