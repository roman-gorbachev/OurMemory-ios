import Foundation

struct VeteranTextForm: Hashable {
    var name = ""
    var baseInfo = ""
    var allInfo = ""
    var entries: [InfoEntry] = []

    var isEmpty: Bool {
        return name.isBlank && baseInfo.isBlank && allInfo.isBlank && InfoEntries.veteransInfo(from: entries).isEmpty
    }

    init(name: String = "", baseInfo: String = "", allInfo: String = "", entries: [InfoEntry] = []) {
        self.name = name
        self.baseInfo = baseInfo
        self.allInfo = allInfo
        self.entries = entries
    }

    init(translation: VeteranTranslation) {
        name = translation.name
        baseInfo = translation.baseInfo
        allInfo = translation.allInfo
        entries = InfoEntries.entries(from: translation.veteransInfo)
    }

    func toTranslation() -> VeteranTranslation {
        return VeteranTranslation(
            name: name.trimmed,
            baseInfo: baseInfo.trimmed,
            allInfo: allInfo.trimmed,
            veteransInfo: InfoEntries.veteransInfo(from: entries)
        )
    }
}
