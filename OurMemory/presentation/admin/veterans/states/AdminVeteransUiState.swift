import Foundation

enum AdminVeteransUiState {
    case loading
    case success(data: [AdminVeteranItemUi])
    case error
}
