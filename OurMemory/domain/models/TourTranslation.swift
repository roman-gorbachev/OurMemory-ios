import Foundation

nonisolated struct TourTranslation: Codable, Hashable, Sendable {
    var title = ""
    var description = ""

    init(title: String = "", description: String = "") {
        self.title = title
        self.description = description
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = container.lenientString(forKey: .title)
        description = container.lenientString(forKey: .description)
    }
}
