import Foundation

struct TourStopUi: Hashable, Identifiable {
    let number: Int
    let title: String
    let type: BurialType
    let burial: BurialUi
    let text: String
    let audio: AudioItem?

    var id: Int {
        return number
    }
}
