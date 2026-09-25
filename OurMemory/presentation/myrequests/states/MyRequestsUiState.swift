import Foundation

enum MyRequestsUiState {
    case loading
    case success(data: [MyRequestItemUi])
    case error
}
