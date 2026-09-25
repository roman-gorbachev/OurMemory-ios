import Foundation

struct InfoEntry: Hashable, Identifiable {
    let id: UUID
    var kind: InfoEntryKind
}
