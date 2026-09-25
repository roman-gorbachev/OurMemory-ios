import Foundation

struct MapContent: Hashable {
    var markers: [MapMarker] = []
    var clustersMarkers = false
    var routeStops: [MapRouteStop] = []
    var isSatellite = false
    var isInteractive = true
}
