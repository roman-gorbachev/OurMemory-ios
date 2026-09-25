import Foundation

enum MapDestination: Hashable {
    case burialMap(burialId: String)
    case tour(tourId: String)
}
