import Foundation

final class YandexDiskDataSourceImpl: YandexDiskDataSource {
    private static let endpoint = "https://cloud-api.yandex.net/v1/disk/public/resources/download"
    private static let publicKeyParameter = "public_key"
    private static let successStatusCodes = 200..<300

    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func downloadLink(publicKey: String) async throws -> YandexImage {
        guard var components = URLComponents(string: Self.endpoint) else {
            throw URLError(.badURL)
        }
        components.queryItems = [URLQueryItem(name: Self.publicKeyParameter, value: publicKey)]
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse, Self.successStatusCodes.contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(YandexDownloadResponse.self, from: data).toDomainModel()
    }
}
