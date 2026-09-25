import Foundation

nonisolated struct Tour: Codable, Hashable, Identifiable, Sendable {
    var id = ""
    var title = ""
    var description = ""
    var stops: [TourStop] = []
    var translations: [String: TourTranslation] = [:]

    init(
        id: String = "",
        title: String = "",
        description: String = "",
        stops: [TourStop] = [],
        translations: [String: TourTranslation] = [:]
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.stops = stops
        self.translations = translations
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = container.lenientString(forKey: .id)
        title = container.lenientString(forKey: .title)
        description = container.lenientString(forKey: .description)
        stops = (try? container.decodeIfPresent([TourStop].self, forKey: .stops)) ?? []
        translations = (try? container.decodeIfPresent([String: TourTranslation].self, forKey: .translations)) ?? [:]
    }

    func localized(to languageKey: String?) -> Tour {
        guard let languageKey else {
            return self
        }
        var tour = self
        if let translation = translations[languageKey] {
            tour.title = translation.title.isBlank ? title : translation.title
            tour.description = translation.description.isBlank ? description : translation.description
        }
        tour.stops = stops.map { return $0.localized(to: languageKey) }
        return tour
    }
}
