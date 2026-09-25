import XCTest
@testable import OurMemory

final class ModerationRepositoryImplTests: XCTestCase {
    func testPendingGoFirstNewestOnTopAndBrokenRecordsAreDropped() async throws {
        let repository = ModerationRepositoryImpl(
            dataSource: FakeModerationDataSource(items: [
                SubmissionDto(id: "approved", status: SubmissionStatusValues.approved, createdAt: 5),
                SubmissionDto(id: "", status: SubmissionStatusValues.pending, createdAt: 9),
                SubmissionDto(id: "old", status: SubmissionStatusValues.pending, createdAt: 1),
                SubmissionDto(id: "new", status: SubmissionStatusValues.pending, createdAt: 3)
            ]),
            veteransRepository: FakeVeteransRepository()
        )
        let submissions = try await repository.submissionsPublisher().firstValue()
        XCTAssertEqual(submissions.map(\.id), ["new", "old", "approved"])
        XCTAssertEqual(submissions.last?.status, .approved)
    }

    func testApprovalRefreshesVeteransCache() async throws {
        let dataSource = FakeModerationDataSource()
        let veterans = FakeVeteransRepository()
        let repository = ModerationRepositoryImpl(dataSource: dataSource, veteransRepository: veterans)
        let approval = SubmissionApproval(
            submission: Submission(id: "s1", veteranId: "10", text: "", contact: "", photoPaths: [], status: .pending, createdAt: 0),
            editedText: "Текст",
            approvedPhotoUrls: [],
            photoCaption: ""
        )
        try await repository.approve(approval)
        XCTAssertEqual(dataSource.approvals, [approval])
        XCTAssertEqual(veterans.invalidations, 1)
    }

    func testPhotoPathsResolveInOrder() async throws {
        let repository = ModerationRepositoryImpl(dataSource: FakeModerationDataSource(), veteransRepository: FakeVeteransRepository())
        let urls = try await repository.resolvePhotoUrls(["a.jpg", "b.jpg"])
        XCTAssertEqual(urls, ["https://storage/a.jpg", "https://storage/b.jpg"])
    }
}
