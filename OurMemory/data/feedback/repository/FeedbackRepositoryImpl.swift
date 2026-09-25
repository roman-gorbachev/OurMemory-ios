import Combine
import Foundation

final class FeedbackRepositoryImpl: FeedbackRepository {
    private let dataSource: FeedbackDataSource

    init(dataSource: FeedbackDataSource) {
        self.dataSource = dataSource
    }

    func send(_ draft: FeedbackDraft) async throws {
        try await dataSource.send(draft)
    }

    func feedbackPublisher() -> AnyPublisher<[Feedback], Error> {
        return dataSource.feedbackPublisher()
            .map { items in
                return items.map { return $0.toDomainModel() }.sorted { first, second in
                    if first.isReviewed != second.isReviewed {
                        return !first.isReviewed
                    }
                    return first.createdAt > second.createdAt
                }
            }
            .eraseToAnyPublisher()
    }

    func markReviewed(feedbackId: String) async throws {
        try await dataSource.markReviewed(feedbackId: feedbackId)
    }

    func reply(feedbackId: String, text: String) async throws {
        try await dataSource.reply(feedbackId: feedbackId, text: text)
    }
}
