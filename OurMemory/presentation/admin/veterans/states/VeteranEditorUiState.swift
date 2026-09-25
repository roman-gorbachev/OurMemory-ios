import Foundation

enum VeteranEditorUiState {
    case loading
    case editing(data: VeteranEditorUiData)
    case error
}
