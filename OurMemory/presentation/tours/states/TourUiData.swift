import Foundation

struct TourUiData: Hashable {
    let title: String
    let description: String
    let stops: [TourStopUi]
    let selectedStopIndex: Int?
    let visitedStops: Set<Int>
}
