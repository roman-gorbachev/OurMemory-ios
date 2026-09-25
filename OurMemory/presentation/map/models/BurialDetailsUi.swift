import Foundation

struct BurialDetailsUi: Hashable, Identifiable {
    let burial: BurialUi
    let type: BurialType
    let photo: String
    let description: String
    let veterans: [VeteranShortUi]

    var id: String {
        return burial.id
    }
}
