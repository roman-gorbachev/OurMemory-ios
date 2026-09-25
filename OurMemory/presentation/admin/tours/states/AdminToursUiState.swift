import Foundation

enum AdminToursUiState {
    case loading
    case success(data: [AdminTourItemUi])
    case error
}
