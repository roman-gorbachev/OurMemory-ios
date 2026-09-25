import Foundation

nonisolated struct TourStop: Codable, Hashable, Sendable {
    var burialId = ""
    var text = ""
    var audioUrl = ""

    init(burialId: String = "", text: String = "", audioUrl: String = "") {
        self.burialId = burialId
        self.text = text
        self.audioUrl = audioUrl
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        burialId = container.lenientString(forKey: .burialId)
        text = container.lenientString(forKey: .text)
        audioUrl = container.lenientString(forKey: .audioUrl)
    }
}
