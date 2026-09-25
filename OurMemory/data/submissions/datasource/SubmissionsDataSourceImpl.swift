import FirebaseDatabase
import FirebaseStorage
import Foundation

final class SubmissionsDataSourceImpl: SubmissionsDataSource {
    private static let jpegType = "image/jpeg"
    private static let jpegExtension = ".jpg"

    private let anonymousSession: AnonymousSession
    private let storage: Storage
    private let root: DatabaseReference

    init(anonymousSession: AnonymousSession, storage: Storage, root: DatabaseReference) {
        self.anonymousSession = anonymousSession
        self.storage = storage
        self.root = root
    }

    func submit(_ draft: SubmissionDraft) async throws {
        let authorUid = try await anonymousSession.ensureSignedIn()
        let reference = root.child(DatabaseNodes.submissions).childByAutoId()
        let submissionId = reference.key ?? UUID().uuidString
        let metadata = StorageMetadata()
        metadata.contentType = Self.jpegType
        var photoPaths: [String] = []
        for (index, photo) in draft.photos.enumerated() {
            let bytes = try await Task.detached { return try PhotoCompressor.compress(photo) }.value
            let path = "\(DatabaseNodes.root)/\(DatabaseNodes.submissions)/\(submissionId)/\(index)\(Self.jpegExtension)"
            _ = try await storage.reference(withPath: path).putDataAsync(bytes, metadata: metadata)
            photoPaths.append(path)
        }
        try await reference.setValue([
            "id": submissionId,
            "authorUid": authorUid,
            "veteranId": draft.veteranId,
            "text": draft.text,
            "contact": draft.contact,
            "photoPaths": photoPaths,
            "status": SubmissionStatusValues.pending,
            "createdAt": ServerValue.timestamp()
        ])
    }
}
