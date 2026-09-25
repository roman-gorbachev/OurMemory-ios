import Combine
import FirebaseDatabase
import Foundation

final class FeedbackDataSourceImpl: FeedbackDataSource {
    private let anonymousSession: AnonymousSession
    private let feedbackReference: DatabaseReference

    init(anonymousSession: AnonymousSession, root: DatabaseReference) {
        self.anonymousSession = anonymousSession
        feedbackReference = root.child(DatabaseNodes.feedback)
    }

    func send(_ draft: FeedbackDraft) async throws {
        let authorUid = try await anonymousSession.ensureSignedIn()
        let reference = feedbackReference.childByAutoId()
        try await reference.setValue([
            "id": reference.key ?? "",
            "authorUid": authorUid,
            "type": draft.type.rawValue,
            "text": draft.text,
            "contact": draft.contact,
            "veteranId": draft.veteranId,
            "status": FeedbackStatusValues.new,
            "createdAt": ServerValue.timestamp()
        ])
    }

    func feedbackPublisher() -> AnyPublisher<[FeedbackDto], Error> {
        return feedbackReference.valuePublisher()
            .map { return $0.childrenAs(FeedbackDto.self) }
            .eraseToAnyPublisher()
    }

    func markReviewed(feedbackId: String) async throws {
        try await feedbackReference.child(feedbackId).updateChildValues([
            "status": FeedbackStatusValues.done,
            "reviewedAt": ServerValue.timestamp()
        ])
    }

    func reply(feedbackId: String, text: String) async throws {
        try await feedbackReference.child(feedbackId).updateChildValues([
            "status": FeedbackStatusValues.done,
            "reply": text,
            "reviewedAt": ServerValue.timestamp()
        ])
    }
}
