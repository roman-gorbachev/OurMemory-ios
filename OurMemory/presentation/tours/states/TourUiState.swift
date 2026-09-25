import Foundation

enum TourUiState {
    case loading
    case success(data: TourUiData)
    case error
}
