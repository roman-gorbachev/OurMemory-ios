import Foundation

struct ReviewPhotoUi: Hashable, Identifiable {
    let url: String
    let isSelected: Bool

    var id: String {
        return url
    }
}
