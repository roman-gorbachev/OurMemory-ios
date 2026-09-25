import Foundation

struct BurialForm: Hashable {
    var id = ""
    var type = BurialType.grave
    var section = ""
    var row = ""
    var place = ""
    var description = ""
    var photo = ""
    var latitude = ""
    var longitude = ""
    var translatedDescriptions: [AppLanguage: String] = [:]
    var language = AppLanguage.russian

    var descriptionText: String {
        get {
            return language == .russian ? description : translatedDescriptions[language] ?? ""
        }
        set {
            if language == .russian {
                description = newValue
            } else {
                translatedDescriptions[language] = newValue
            }
        }
    }

    var latitudeValue: Double? {
        return Coordinates.latitude(from: latitude)
    }

    var longitudeValue: Double? {
        return Coordinates.longitude(from: longitude)
    }

    var isValid: Bool {
        return latitudeValue != nil && longitudeValue != nil
    }

    init(id: String, latitude: Double, longitude: Double) {
        self.id = id
        self.latitude = Coordinates.text(latitude)
        self.longitude = Coordinates.text(longitude)
    }

    init(burial: Burial) {
        id = burial.id
        type = BurialType(value: burial.type)
        section = burial.section
        row = burial.row
        place = burial.place
        description = burial.description
        photo = burial.photo
        latitude = Coordinates.text(burial.latitude)
        longitude = Coordinates.text(burial.longitude)
        translatedDescriptions = AppLanguage.translated(burial.translations).mapValues { return $0.description }
    }

    func toBurial() -> Burial {
        return Burial(
            id: id,
            latitude: latitudeValue ?? 0,
            longitude: longitudeValue ?? 0,
            section: section.trimmed,
            row: row.trimmed,
            place: place.trimmed,
            type: type.rawValue,
            photo: photo,
            description: description.trimmed,
            translations: AppLanguage.stored(translatedDescriptions.filter { return !$0.value.isBlank })
                .mapValues { return BurialTranslation(description: $0.trimmed) }
        )
    }
}
