import Combine
import Foundation
@testable import OurMemory

final class FakeFeedbackDataSource: FeedbackDataSource {
    let items: CurrentValueSubject<[FeedbackDto], Error>
    private(set) var drafts: [FeedbackDraft] = []

    init(items: [FeedbackDto] = []) {
        self.items = CurrentValueSubject(items)
    }

    func send(_ draft: FeedbackDraft) async throws {
        drafts.append(draft)
    }

    func feedbackPublisher() -> AnyPublisher<[FeedbackDto], Error> {
        return items.eraseToAnyPublisher()
    }

    func markReviewed(feedbackId: String) async throws {
        items.send(items.value.map { item in
            guard item.id == feedbackId else {
                return item
            }
            var updated = item
            updated.status = FeedbackStatusValues.done
            return updated
        })
    }

    func reply(feedbackId: String, text: String) async throws {
        items.send(items.value.map { item in
            guard item.id == feedbackId else {
                return item
            }
            var updated = item
            updated.status = FeedbackStatusValues.done
            updated.reply = text
            return updated
        })
    }
}
