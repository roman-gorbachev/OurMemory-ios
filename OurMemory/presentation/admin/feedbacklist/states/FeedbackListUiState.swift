import Foundation

enum FeedbackListUiState {
    case loading
    case success(data: [FeedbackItemUi])
    case error
}
