import Combine
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Foundation

final class ModerationDataSourceImpl: ModerationDataSource {
    private static let veteransInfoField = "veteransInfo"
    private static let firebaseErrorDomain = "com.firebase"
    private static let permissionDeniedCode = 1

    private let auth: Auth
    private let storage: Storage
    private let root: DatabaseReference
    private let submissionsReference: DatabaseReference

    init(auth: Auth, storage: Storage, root: DatabaseReference) {
        self.auth = auth
        self.storage = storage
        self.root = root
        submissionsReference = root.child(DatabaseNodes.submissions)
    }

    func submissionsPublisher() -> AnyPublisher<[SubmissionDto], Error> {
        return submissionsReference.valuePublisher()
            .map { return $0.childrenAs(SubmissionDto.self) }
            .eraseToAnyPublisher()
    }

    func resolvePhotoUrl(_ photoPath: String) async throws -> String {
        return try await storage.reference(withPath: photoPath).downloadURL().absoluteString
    }

    func approve(_ approval: SubmissionApproval) async throws {
        let veteranId = approval.submission.veteranId
        let veteran = try await root.child(DatabaseNodes.veterans).child(VeteranKeys.forId(veteranId)).getData()
        guard veteran.exists() else {
            throw ModerationError.veteranNotFound(veteranId)
        }
        let updates = ApprovalUpdates.updates(
            for: approval,
            currentInfo: veteran.childSnapshot(forPath: Self.veteransInfoField).childStrings,
            reviewer: auth.currentUser?.email ?? "",
            reviewedAt: ServerValue.timestamp()
        )
        try await updateOrThrow(root, updates)
    }

    func reject(submissionId: String, reply: String) async throws {
        try await updateOrThrow(submissionsReference.child(submissionId), [
            "status": SubmissionStatusValues.rejected,
            "reviewedBy": auth.currentUser?.email ?? "",
            "reviewedAt": ServerValue.timestamp(),
            "reply": reply.trimmingCharacters(in: .whitespacesAndNewlines)
        ])
    }

    private func updateOrThrow(_ reference: DatabaseReference, _ updates: [String: Any]) async throws {
        do {
            try await reference.updateChildValues(updates)
        } catch let error as NSError where error.domain == Self.firebaseErrorDomain && error.code == Self.permissionDeniedCode {
            throw ModerationError.permissionDenied
        }
    }
}
