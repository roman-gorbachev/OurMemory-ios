import Foundation

struct SubmissionReviewUiData: Hashable {
    let veteranName: String
    let contact: String
    let date: String
    let text: String
    let reply: String
    let photos: [ReviewPhotoUi]
    let status: ModerationStatus
    let isProcessing: Bool
    let failure: ReviewFailure?
    let isFinished: Bool

    var isEditable: Bool {
        return status == .pending && !isProcessing
    }
}
