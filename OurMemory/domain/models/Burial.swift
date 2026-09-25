import Foundation

nonisolated struct Burial: Codable, Hashable, Identifiable, Sendable {
    var id = ""
    var latitude = 0.0
    var longitude = 0.0
    var section = ""
    var row = ""
    var place = ""
    var type = ""
    var photo = ""
    var description = ""
    var translations: [String: BurialTranslation] = [:]

    init(
        id: String = "",
        latitude: Double = 0.0,
        longitude: Double = 0.0,
        section: String = "",
        row: String = "",
        place: String = "",
        type: String = "",
        photo: String = "",
        description: String = "",
        translations: [String: BurialTranslation] = [:]
    ) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.section = section
        self.row = row
        self.place = place
        self.type = type
        self.photo = photo
        self.description = description
        self.translations = translations
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = container.lenientString(forKey: .id)
        latitude = container.lenientDouble(forKey: .latitude)
        longitude = container.lenientDouble(forKey: .longitude)
        section = container.lenientString(forKey: .section)
        row = container.lenientString(forKey: .row)
        place = container.lenientString(forKey: .place)
        type = container.lenientString(forKey: .type)
        photo = container.lenientString(forKey: .photo)
        description = container.lenientString(forKey: .description)
        translations = (try? container.decodeIfPresent([String: BurialTranslation].self, forKey: .translations)) ?? [:]
    }

    func localized(to languageKey: String?) -> Burial {
        guard let languageKey, let translation = translations[languageKey], !translation.description.isBlank else {
            return self
        }
        var burial = self
        burial.description = translation.description
        return burial
    }
}
