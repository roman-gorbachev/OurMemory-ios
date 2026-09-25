import Foundation

nonisolated struct SubmissionApproval: Hashable, Sendable {
    let submission: Submission
    let editedText: String
    let approvedPhotoUrls: [String]
    let photoCaption: String
    var reply = ""
}
