import Foundation

enum TourEditorUserAction {
    case languageChanged(AppLanguage)
    case titleChanged(String)
    case descriptionChanged(String)
    case stopAdded(burialId: String)
    case stopTextChanged(UUID, String)
    case stopAudioPicked(UUID, URL)
    case stopAudioRemoved(UUID)
    case stopsMoved(IndexSet, Int)
    case stopsRemoved(IndexSet)
    case failureDismissed
    case save
    case delete
}
