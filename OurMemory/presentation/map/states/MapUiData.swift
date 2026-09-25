import Foundation

struct MapUiData: Hashable {
    var markers: [MapMarker] = []
    var selectedBurial: BurialDetailsUi?
    var checkedWar = true
    var checkedArt = true
    var tours: [TourSummaryUi] = []
}
