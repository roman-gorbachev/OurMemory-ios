import Foundation

enum ModerationListUiState {
    case loading
    case success(data: [SubmissionItemUi])
    case error
}
