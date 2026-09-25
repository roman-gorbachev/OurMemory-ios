import Foundation

struct TourForm: Hashable {
    var id = ""
    var title = ""
    var description = ""
    var stops: [TourStopForm] = []
    var translations: [AppLanguage: TourTranslation] = [:]
    var language = AppLanguage.russian

    var isValid: Bool {
        return !title.isBlank && !stops.isEmpty
    }

    var text: TourTranslation {
        get {
            return language == .russian ? TourTranslation(title: title, description: description) : translations[language] ?? TourTranslation()
        }
        set {
            if language == .russian {
                title = newValue.title
                description = newValue.description
            } else {
                translations[language] = newValue
            }
        }
    }

    init(id: String) {
        self.id = id
    }

    init(tour: Tour) {
        id = tour.id
        title = tour.title
        description = tour.description
        stops = tour.stops.map { return TourStopForm(stop: $0) }
        translations = AppLanguage.translated(tour.translations)
    }

    func toTour() -> Tour {
        let storedTranslations = translations
            .mapValues { return TourTranslation(title: $0.title.trimmed, description: $0.description.trimmed) }
            .filter { return !$0.value.title.isEmpty || !$0.value.description.isEmpty }
        return Tour(
            id: id,
            title: title.trimmed,
            description: description.trimmed,
            stops: stops.map { return $0.toTourStop() },
            translations: AppLanguage.stored(storedTranslations)
        )
    }
}
