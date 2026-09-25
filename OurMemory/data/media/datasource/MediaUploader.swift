import FirebaseStorage
import Foundation
import UniformTypeIdentifiers

final class MediaUploader: MediaRepository {
    private static let mediaFolder = "Media"
    private static let jpegType = "image/jpeg"
    private static let jpegExtension = ".jpg"
    private static let defaultAudioType = "audio/mpeg"

    private let storage: Storage

    init(storage: Storage) {
        self.storage = storage
    }

    func uploadPhoto(_ imageData: Data, folder: String) async throws -> String {
        let bytes = try await Task.detached { return try PhotoCompressor.compress(imageData) }.value
        let reference = mediaReference(folder: folder, fileName: UUID().uuidString + Self.jpegExtension)
        let metadata = StorageMetadata()
        metadata.contentType = Self.jpegType
        try await upload { _ = try await reference.putDataAsync(bytes, metadata: metadata) }
        return try await reference.downloadURL().absoluteString
    }

    func uploadAudio(fileURL: URL, folder: String) async throws -> String {
        let reference = mediaReference(folder: folder, fileName: UUID().uuidString)
        let metadata = StorageMetadata()
        metadata.contentType = UTType(filenameExtension: fileURL.pathExtension)?.preferredMIMEType ?? Self.defaultAudioType
        try await upload { _ = try await reference.putFileAsync(from: fileURL, metadata: metadata) }
        return try await reference.downloadURL().absoluteString
    }

    private func upload(_ operation: () async throws -> Void) async throws {
        do {
            try await operation()
        } catch let error as NSError where error.domain == StorageErrorDomain && StorageErrorCode(rawValue: error.code) == .unauthorized {
            throw MediaError.uploadDenied
        }
    }

    private func mediaReference(folder: String, fileName: String) -> StorageReference {
        return storage.reference(withPath: "\(DatabaseNodes.root)/\(Self.mediaFolder)/\(folder)/\(fileName)")
    }
}
