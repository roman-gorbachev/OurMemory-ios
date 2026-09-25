import Foundation

struct DetailsUiData: Hashable {
    let veteranId: String
    let name: String
    let years: String
    let portrait: String
    let rewards: [RewardCount]
    let paragraphs: [String]
    let media: [MediaUi]
    let audio: AudioItem?
    let burial: BurialUi?
}
