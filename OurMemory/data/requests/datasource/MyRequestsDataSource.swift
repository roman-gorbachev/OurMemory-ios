import Combine
import Foundation

protocol MyRequestsDataSource: AnyObject {
    func currentUidPublisher() -> AnyPublisher<String?, Never>
    func submissionsPublisher(authorUid: String) -> AnyPublisher<[SubmissionDto], Error>
    func feedbackPublisher(authorUid: String) -> AnyPublisher<[FeedbackDto], Error>
}
