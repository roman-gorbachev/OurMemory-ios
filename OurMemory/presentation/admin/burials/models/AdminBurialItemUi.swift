import Foundation

struct AdminBurialItemUi: Hashable, Identifiable {
    let burial: BurialUi
    let type: BurialType
    let veteranNames: String

    var id: String {
        return burial.id
    }
}
