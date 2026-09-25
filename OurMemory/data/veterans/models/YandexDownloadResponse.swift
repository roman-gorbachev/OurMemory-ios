import Foundation

nonisolated struct YandexDownloadResponse: Decodable, Sendable {
    var method = ""
    var href = ""
    var templated = false

    private enum CodingKeys: String, CodingKey {
        case method
        case href
        case templated
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        method = (try? container.decodeIfPresent(String.self, forKey: .method)) ?? ""
        href = (try? container.decodeIfPresent(String.self, forKey: .href)) ?? ""
        templated = (try? container.decodeIfPresent(Bool.self, forKey: .templated)) ?? false
    }

    func toDomainModel() -> YandexImage {
        return YandexImage(href: href)
    }
}
