import Foundation

nonisolated struct VeteranTranslation: Codable, Hashable, Sendable {
    var name = ""
    var baseInfo = ""
    var allInfo = ""
    var veteransInfo: [String] = []

    init(name: String = "", baseInfo: String = "", allInfo: String = "", veteransInfo: [String] = []) {
        self.name = name
        self.baseInfo = baseInfo
        self.allInfo = allInfo
        self.veteransInfo = veteransInfo
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = container.lenientString(forKey: .name)
        baseInfo = container.lenientString(forKey: .baseInfo)
        allInfo = container.lenientString(forKey: .allInfo)
        veteransInfo = container.lenientStrings(forKey: .veteransInfo)
    }
}
