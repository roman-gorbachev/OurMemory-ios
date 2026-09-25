import Combine
import Foundation

protocol ModerationRepository: AnyObject {
    func submissionsPublisher() -> AnyPublisher<[Submission], Error>
    func resolvePhotoUrls(_ photoPaths: [String]) async throws -> [String]
    func approve(_ approval: SubmissionApproval) async throws
    func reject(submissionId: String, reply: String) async throws
}
