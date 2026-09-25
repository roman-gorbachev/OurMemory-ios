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
            deathDate: deathDate
        )
    }

    static func nextId(after veterans: [Veteran]) -> String {
        return String((veterans.compactMap { return Int($0.id) }.max() ?? 0) + 1)
    }
}
