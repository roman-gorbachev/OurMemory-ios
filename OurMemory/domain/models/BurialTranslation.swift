import Foundation

nonisolated struct BurialTranslation: Codable, Hashable, Sendable {
    var description = ""

    init(description: String = "") {
        self.description = description
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        description = container.lenientString(forKey: .description)
    }
}
