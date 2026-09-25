import Combine
import Foundation
@testable import OurMemory

final class FakeModerationDataSource: ModerationDataSource {
    private static let storageUrlPrefix = "https://storage/"

    let items: CurrentValueSubject<[SubmissionDto], Error>
    private(set) var approvals: [SubmissionApproval] = []
    private(set) var rejections: [String] = []

    init(items: [SubmissionDto] = []) {
        self.items = CurrentValueSubject(items)
    }

    func submissionsPublisher() -> AnyPublisher<[SubmissionDto], Error> {
        return items.eraseToAnyPublisher()
    }

    func resolvePhotoUrl(_ photoPath: String) async throws -> String {
        return Self.storageUrlPrefix + photoPath
    }

    func approve(_ approval: SubmissionApproval) async throws {
        approvals.append(approval)
    }

    func reject(submissionId: String, reply: String) async throws {
        rejections.append(submissionId)
    }
}
