import Foundation

protocol MediaRepository: AnyObject {
    func uploadPhoto(_ imageData: Data, folder: String) async throws -> String
    func uploadAudio(fileURL: URL, folder: String) async throws -> String
}
