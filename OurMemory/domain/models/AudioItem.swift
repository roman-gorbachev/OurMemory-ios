import Foundation

nonisolated struct AudioItem: Hashable, Sendable {
    let id: String
    let url: URL
    let title: String
    var subtitle = ""
}
