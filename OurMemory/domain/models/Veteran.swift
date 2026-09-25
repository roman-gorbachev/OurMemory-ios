import Foundation

nonisolated struct Veteran: Codable, Hashable, Identifiable, Sendable {
    var id = ""
    var name = ""
    var portrait = ""
    var baseInfo = ""
    var allInfo = ""
    var years = ""
    var category = ""
    var rewards = ""
    var veteransInfo: [String] = []
    var burialId = ""
    var audioUrl = ""
    var birthDate = ""
    var deathDate = ""

    init(
        id: String = "",
        name: String = "",
        portrait: String = "",
        baseInfo: String = "",
        allInfo: String = "",
        years: String = "",
        category: String = "",
        rewards: String = "",
        veteransInfo: [String] = [],
        burialId: String = "",
        audioUrl: String = "",
        birthDate: String = "",
        deathDate: String = ""
    ) {
        self.id = id
        self.name = name
        self.portrait = portrait
        self.baseInfo = baseInfo
        self.allInfo = allInfo
        self.years = years
        self.category = category
        self.rewards = rewards
        self.veteransInfo = veteransInfo
        self.burialId = burialId
        self.audioUrl = audioUrl
        self.birthDate = birthDate
        self.deathDate = deathDate
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = container.lenientString(forKey: .id)
        name = container.lenientString(forKey: .name)
        portrait = container.lenientString(forKey: .portrait)
        baseInfo = container.lenientString(forKey: .baseInfo)
        allInfo = container.lenientString(forKey: .allInfo)
        years = container.lenientString(forKey: .years)
        category = container.lenientString(forKey: .category)
        rewards = container.lenientString(forKey: .rewards)
        veteransInfo = container.lenientStrings(forKey: .veteransInfo)
        burialId = container.lenientString(forKey: .burialId)
        audioUrl = container.lenientString(forKey: .audioUrl)
        birthDate = container.lenientString(forKey: .birthDate)
        deathDate = container.lenientString(forKey: .deathDate)
    }
}
