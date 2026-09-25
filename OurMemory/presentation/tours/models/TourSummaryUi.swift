import Foundation

struct TourSummaryUi: Hashable, Identifiable {
    let id: String
    let title: String
    let description: String
    let stopsCount: Int
    var visitedCount = 0
}
