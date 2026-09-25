import Foundation

struct PickedPhoto: Hashable, Identifiable {
    let id: UUID
    let data: Data
}
