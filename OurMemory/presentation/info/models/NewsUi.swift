import Foundation

struct NewsUi: Hashable, Identifiable {
    let imageName: String
    let title: String
    let url: URL

    var id: String {
        return title
    }
}
