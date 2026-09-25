import Foundation

struct MediaUi: Hashable, Identifiable {
    let url: String
    let description: String

    var id: String {
        return url + description
    }
}
