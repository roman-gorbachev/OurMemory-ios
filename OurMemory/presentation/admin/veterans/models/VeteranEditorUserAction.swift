import Foundation

enum VeteranEditorUserAction {
    case languageChanged(AppLanguage)
    case nameChanged(String)
    case yearsChanged(String)
    case categoryChanged(VeteranCategory)
    case baseInfoChanged(String)
    case allInfoChanged(String)
    case rewardCountChanged(Reward, delta: Int)
    case birthDateChanged(String)
    case deathDateChanged(String)
    case burialChanged(String)
    case portraitPicked(Data)
    case audioPicked(URL)
    case audioRemoved
    case paragraphAdded
    case paragraphsCopiedFromOriginal
    case mediaPicked(Data)
    case entryChanged(InfoEntry)
    case entryMoved(UUID, offset: Int)
    case entryRemoved(UUID)
    case failureDismissed
    case save
    case delete
}
