import Foundation

protocol SubmissionsDataSource: AnyObject {
    func submit(_ draft: SubmissionDraft) async throws
}
