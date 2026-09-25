import Combine
import FirebaseAuth
import FirebaseDatabase
import Foundation

final class MyRequestsDataSourceImpl: MyRequestsDataSource {
    private static let authorUidField = "authorUid"

    private let auth: Auth
    private let root: DatabaseReference

    init(auth: Auth, root: DatabaseReference) {
        self.auth = auth
        self.root = root
    }

    func currentUidPublisher() -> AnyPublisher<String?, Never> {
        return auth.userPublisher().map { return $0?.uid }.eraseToAnyPublisher()
    }

    func submissionsPublisher(authorUid: String) -> AnyPublisher<[SubmissionDto], Error> {
        return authored(by: authorUid, in: DatabaseNodes.submissions)
            .map { return $0.childrenAs(SubmissionDto.self) }
            .eraseToAnyPublisher()
    }

    func feedbackPublisher(authorUid: String) -> AnyPublisher<[FeedbackDto], Error> {
        return authored(by: authorUid, in: DatabaseNodes.feedback)
            .map { return $0.childrenAs(FeedbackDto.self) }
            .eraseToAnyPublisher()
    }

    private func authored(by authorUid: String, in node: String) -> AnyPublisher<DataSnapshot, Error> {
        return root.child(node)
            .queryOrdered(byChild: Self.authorUidField)
            .queryEqual(toValue: authorUid)
            .valuePublisher()
    }
}
