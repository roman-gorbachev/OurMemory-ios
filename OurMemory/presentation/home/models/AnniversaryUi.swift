import Foundation

struct AnniversaryUi: Hashable, Identifiable {
    let veteranId: String
    let name: String
    let portrait: String
    let isBirthday: Bool
    let year: Int

    var id: String {
        return "\(veteranId)_\(isBirthday)"
    }
}
