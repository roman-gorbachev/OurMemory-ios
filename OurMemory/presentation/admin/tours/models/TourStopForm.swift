import Foundation

struct TourStopForm: Hashable, Identifiable {
    let id: UUID
    var burialId: String
    var text = ""
    var audioUrl = ""
    var translations: [AppLanguage: TourStopTranslation] = [:]

    init(burialId: String) {
        id = UUID()
        self.burialId = burialId
    }

    init(stop: TourStop) {
        id = UUID()
        burialId = stop.burialId
        text = stop.text
        audioUrl = stop.audioUrl
        translations = AppLanguage.translated(stop.translations)
    }

    func content(in language: AppLanguage) -> TourStopTranslation {
        return language == .russian ? TourStopTranslation(text: text, audioUrl: audioUrl) : translations[language] ?? TourStopTranslation()
    }

    mutating func setContent(_ content: TourStopTranslation, in language: AppLanguage) {
        guard language != .russian else {
            text = content.text
            audioUrl = content.audioUrl
            return
        }
        translations[language] = content
    }

    func toTourStop() -> TourStop {
        let storedTranslations = translations
            .mapValues { return TourStopTranslation(text: $0.text.trimmed, audioUrl: $0.audioUrl) }
            .filter { return !$0.value.text.isEmpty || !$0.value.audioUrl.isEmpty }
        return TourStop(burialId: burialId, text: text.trimmed, audioUrl: audioUrl, translations: AppLanguage.stored(storedTranslations))
    }
}
