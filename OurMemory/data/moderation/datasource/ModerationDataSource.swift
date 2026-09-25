import Combine
import Foundation

protocol ModerationDataSource: AnyObject {
    func submissionsPublisher() -> AnyPublisher<[SubmissionDto], Error>
    func resolvePhotoUrl(_ photoPath: String) async throws -> String
    func approve(_ approval: SubmissionApproval) async throws
    func reject(submissionId: String, reply: String) async throws
}
