import Foundation

nonisolated struct TourStopTranslation: Codable, Hashable, Sendable {
    var text = ""
    var audioUrl = ""

    init(text: String = "", audioUrl: String = "") {
        self.text = text
        self.audioUrl = audioUrl
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = container.lenientString(forKey: .text)
        audioUrl = container.lenientString(forKey: .audioUrl)
    }
}
