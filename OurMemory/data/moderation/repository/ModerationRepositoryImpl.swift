import Combine
import Foundation

final class ModerationRepositoryImpl: ModerationRepository {
    private let dataSource: ModerationDataSource
    private let veteransRepository: VeteransRepository

    init(dataSource: ModerationDataSource, veteransRepository: VeteransRepository) {
        self.dataSource = dataSource
        self.veteransRepository = veteransRepository
    }

    func submissionsPublisher() -> AnyPublisher<[Submission], Error> {
        return dataSource.submissionsPublisher()
            .map { items in
                return items
                    .filter { return !$0.id.trimmingCharacters(in: .whitespaces).isEmpty }
                    .map { return $0.toDomainModel() }
                    .sorted { first, second in
                        let firstPending = first.status == .pending
                        let secondPending = second.status == .pending
                        if firstPending != secondPending {
                            return firstPending
                        }
                        return first.createdAt > second.createdAt
                    }
            }
            .eraseToAnyPublisher()
    }

    func resolvePhotoUrls(_ photoPaths: [String]) async throws -> [String] {
        let dataSource = dataSource
        return try await withThrowingTaskGroup(of: (Int, String).self) { group in
            for (index, path) in photoPaths.enumerated() {
                group.addTask { return (index, try await dataSource.resolvePhotoUrl(path)) }
            }
            var urls = Array(repeating: "", count: photoPaths.count)
            for try await (index, url) in group {
                urls[index] = url
            }
            return urls
        }
    }

    func approve(_ approval: SubmissionApproval) async throws {
        try await dataSource.approve(approval)
        veteransRepository.invalidate()
    }

    func reject(submissionId: String, reply: String) async throws {
        try await dataSource.reject(submissionId: submissionId, reply: reply)
    }
}
