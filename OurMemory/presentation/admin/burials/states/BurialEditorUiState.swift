import Foundation

enum BurialEditorUiState {
    case loading
    case editing(data: BurialEditorUiData)
    case error
}
