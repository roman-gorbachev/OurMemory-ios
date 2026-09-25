import Foundation

enum TourEditorUiState {
    case loading
    case editing(data: TourEditorUiData)
    case error
}
