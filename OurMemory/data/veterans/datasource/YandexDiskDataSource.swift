import Foundation

protocol YandexDiskDataSource: AnyObject {
    func downloadLink(publicKey: String) async throws -> YandexImage
}
