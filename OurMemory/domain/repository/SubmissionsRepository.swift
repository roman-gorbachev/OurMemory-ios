import Foundation

protocol SubmissionsRepository: AnyObject {
    func submit(_ draft: SubmissionDraft) async throws
}
