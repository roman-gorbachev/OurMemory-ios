import Foundation

struct TourForm: Hashable {
    var id = ""
    var title = ""
    var description = ""
    var stops: [TourStopForm] = []

    var isValid: Bool {
        return !title.isBlank && !stops.isEmpty
    }

    init(id: String) {
        self.id = id
    }

    init(tour: Tour) {
        id = tour.id
        title = tour.title
        description = tour.description
        stops = tour.stops.map { return TourStopForm(stop: $0) }
    }

    func toTour() -> Tour {
        return Tour(id: id, title: title.trimmed, description: description.trimmed, stops: stops.map { return $0.toTourStop() })
    }
}
