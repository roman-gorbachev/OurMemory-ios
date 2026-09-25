import Foundation

nonisolated struct TourStop: Codable, Hashable, Sendable {
    var burialId = ""
    var text = ""
    var audioUrl = ""
    var translations: [String: TourStopTranslation] = [:]

    init(
        burialId: String = "",
        text: String = "",
        audioUrl: String = "",
        translations: [String: TourStopTranslation] = [:]
    ) {
        self.burialId = burialId
        self.text = text
        self.audioUrl = audioUrl
        self.translations = translations
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        burialId = container.lenientString(forKey: .burialId)
        text = container.lenientString(forKey: .text)
        audioUrl = container.lenientString(forKey: .audioUrl)
        translations = (try? container.decodeIfPresent([String: TourStopTranslation].self, forKey: .translations)) ?? [:]
    }

    func localized(to languageKey: String?) -> TourStop {
        guard let languageKey, let translation = translations[languageKey] else {
            return self
        }
        var stop = self
        stop.text = translation.text.isBlank ? text : translation.text
        stop.audioUrl = translation.audioUrl.isBlank ? audioUrl : translation.audioUrl
        return stop
    }
}
