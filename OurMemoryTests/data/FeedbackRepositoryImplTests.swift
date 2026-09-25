import XCTest
@testable import OurMemory

final class FeedbackRepositoryImplTests: XCTestCase {
    func testNewFeedbackGoesFirstAndNewestOnTop() async throws {
        let repository = FeedbackRepositoryImpl(dataSource: FakeFeedbackDataSource(items: [
            FeedbackDto(id: "old-done", status: FeedbackStatusValues.done, createdAt: 3),
            FeedbackDto(id: "old-new", status: FeedbackStatusValues.new, createdAt: 1),
            FeedbackDto(id: "fresh-new", status: FeedbackStatusValues.new, createdAt: 2)
        ]))
        let ids = try await repository.feedbackPublisher().firstValue().map(\.id)
        XCTAssertEqual(ids, ["fresh-new", "old-new", "old-done"])
    }

    func testUnknownTypeFallsBackToOther() async throws {
        let repository = FeedbackRepositoryImpl(dataSource: FakeFeedbackDataSource(items: [
            FeedbackDto(id: "a", type: FeedbackType.dataError.rawValue),
            FeedbackDto(id: "b", type: "SPAM")
        ]))
        let types = try await repository.feedbackPublisher().firstValue().map(\.type)
        XCTAssertEqual(types, [.dataError, .other])
    }
}
