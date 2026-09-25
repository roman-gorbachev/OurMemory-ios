import Foundation

struct BurialUi: Hashable, Identifiable {
    let id: String
    let latitude: Double
    let longitude: Double
    let section: String
    let row: String
    let place: String

    var hasPlotNumber: Bool {
        return !section.isBlank && !row.isBlank && !place.isBlank
    }

    var hasCoordinates: Bool {
        return latitude != 0 || longitude != 0
    }
}
