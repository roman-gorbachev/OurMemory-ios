import Foundation

extension Burial {
    func toUiModel() -> BurialUi {
        return BurialUi(id: id, latitude: latitude, longitude: longitude, section: section, row: row, place: place)
    }
}
