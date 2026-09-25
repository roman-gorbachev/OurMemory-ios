import Foundation

enum SubmissionReviewUiState {
    case loading
    case success(data: SubmissionReviewUiData)
    case error
}
