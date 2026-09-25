import Foundation

struct VeteranForm: Hashable {
    var id = ""
    var name = ""
    var years = ""
    var category = VeteranCategory.war
    var baseInfo = ""
    var allInfo = ""
    var rewards: [Reward: Int] = [:]
    var birthDate = ""
    var deathDate = ""
    var portrait = ""
    var audioUrl = ""
    var burialId = ""
    var entries: [InfoEntry] = []
    var translations: [AppLanguage: VeteranTextForm] = [:]
    var language = AppLanguage.russian

    var original: VeteranTextForm {
        return VeteranTextForm(name: name, baseInfo: baseInfo, allInfo: allInfo, entries: entries)
    }

    var text: VeteranTextForm {
        get {
            return text(in: language)
        }
        set {
            setText(newValue, in: language)
        }
    }

    func text(in language: AppLanguage) -> VeteranTextForm {
        return language == .russian ? original : translations[language] ?? VeteranTextForm()
    }

    mutating func setText(_ text: VeteranTextForm, in language: AppLanguage) {
        guard language != .russian else {
            name = text.name
            baseInfo = text.baseInfo
            allInfo = text.allInfo
            entries = text.entries
            return
        }
        translations[language] = text
    }

    var isNameValid: Bool {
        return !name.isBlank
    }

    var isBirthDateValid: Bool {
        return IsoDate.isBlankOrValid(birthDate)
    }

    var isDeathDateValid: Bool {
        return IsoDate.isBlankOrValid(deathDate)
    }

    var isValid: Bool {
        return isNameValid && isBirthDateValid && isDeathDateValid
    }

    init(id: String) {
        self.id = id
    }

    init(veteran: Veteran) {
        id = veteran.id
        name = veteran.name
        years = veteran.years
        category = VeteranCategory(value: veteran.category)
        baseInfo = veteran.baseInfo
        allInfo = veteran.allInfo
        rewards = RewardsParser.counts(from: veteran.rewards)
        birthDate = veteran.birthDate
        deathDate = veteran.deathDate
        portrait = veteran.portrait
        audioUrl = veteran.audioUrl
        burialId = veteran.burialId
        entries = InfoEntries.entries(from: veteran.veteransInfo)
        translations = AppLanguage.translated(veteran.translations).mapValues { return VeteranTextForm(translation: $0) }
    }

    func toVeteran() -> Veteran {
        return Veteran(
            id: id,
            name: name.trimmed,
            portrait: portrait,
            baseInfo: baseInfo.trimmed,
            allInfo: allInfo.trimmed,
            years: years.trimmed,
            category: category.rawValue,
            rewards: RewardsParser.rewardsString(from: rewards),
            veteransInfo: InfoEntries.veteransInfo(from: entries),
            burialId: burialId,
            audioUrl: audioUrl,
            birthDate: birthDate,
            deathDate: deathDate,
            translations: AppLanguage.stored(translations.filter { return !$0.value.isEmpty }).mapValues { return $0.toTranslation() }
        )
    }

    static func nextId(after veterans: [Veteran]) -> String {
        return String((veterans.compactMap { return Int($0.id) }.max() ?? 0) + 1)
    }
}
