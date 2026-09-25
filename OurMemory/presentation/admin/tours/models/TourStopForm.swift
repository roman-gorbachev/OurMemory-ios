import Foundation

struct TourStopForm: Hashable, Identifiable {
    let id: UUID
    var burialId: String
    var text = ""
    var audioUrl = ""

    init(burialId: String) {
        id = UUID()
        self.burialId = burialId
    }

    init(stop: TourStop) {
        id = UUID()
        burialId = stop.burialId
        text = stop.text
        audioUrl = stop.audioUrl
    }

    func toTourStop() -> TourStop {
        return TourStop(burialId: burialId, text: text.trimmed, audioUrl: audioUrl)
    }
}
