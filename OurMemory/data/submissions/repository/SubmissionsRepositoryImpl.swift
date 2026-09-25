import Foundation

final class SubmissionsRepositoryImpl: SubmissionsRepository {
    private let dataSource: SubmissionsDataSource

    init(dataSource: SubmissionsDataSource) {
        self.dataSource = dataSource
    }

    func submit(_ draft: SubmissionDraft) async throws {
        try await dataSource.submit(draft)
    }
}
