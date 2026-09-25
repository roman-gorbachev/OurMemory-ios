import Combine
import Foundation

protocol FeedbackDataSource: AnyObject {
    func send(_ draft: FeedbackDraft) async throws
    func feedbackPublisher() -> AnyPublisher<[FeedbackDto], Error>
    func markReviewed(feedbackId: String) async throws
    func reply(feedbackId: String, text: String) async throws
}
