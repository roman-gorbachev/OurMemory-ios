import Combine
import Foundation

protocol FeedbackRepository: AnyObject {
    func send(_ draft: FeedbackDraft) async throws
    func feedbackPublisher() -> AnyPublisher<[Feedback], Error>
    func markReviewed(feedbackId: String) async throws
    func reply(feedbackId: String, text: String) async throws
}
