import Foundation

nonisolated struct Tour: Codable, Hashable, Identifiable, Sendable {
    var id = ""
    var title = ""
    var description = ""
    var stops: [TourStop] = []

    init(id: String = "", title: String = "", description: String = "", stops: [TourStop] = []) {
        self.id = id
        self.title = title
        self.description = description
        self.stops = stops
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = container.lenientString(forKey: .id)
        title = container.lenientString(forKey: .title)
        description = container.lenientString(forKey: .description)
        stops = (try? container.decodeIfPresent([TourStop].self, forKey: .stops)) ?? []
    }
}
