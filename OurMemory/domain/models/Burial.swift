import Foundation

nonisolated struct Burial: Codable, Hashable, Identifiable, Sendable {
    var id = ""
    var latitude = 0.0
    var longitude = 0.0
    var section = ""
    var row = ""
    var place = ""
    var type = ""
    var photo = ""
    var description = ""

    init(
        id: String = "",
        latitude: Double = 0.0,
        longitude: Double = 0.0,
        section: String = "",
        row: String = "",
        place: String = "",
        type: String = "",
        photo: String = "",
        description: String = ""
    ) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.section = section
        self.row = row
        self.place = place
        self.type = type
        self.photo = photo
        self.description = description
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = container.lenientString(forKey: .id)
        latitude = container.lenientDouble(forKey: .latitude)
        longitude = container.lenientDouble(forKey: .longitude)
        section = container.lenientString(forKey: .section)
        row = container.lenientString(forKey: .row)
        place = container.lenientString(forKey: .place)
        type = container.lenientString(forKey: .type)
        photo = container.lenientString(forKey: .photo)
        description = container.lenientString(forKey: .description)
    }
}
