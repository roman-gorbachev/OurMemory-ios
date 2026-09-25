import Foundation

struct TourEditorUiData: Hashable {
    let form: TourForm
    let burials: [AdminBurialItemUi]
    let isNew: Bool
    let status: EditorStatus

    var canSave: Bool {
        return form.isValid && !status.isBusy
    }

    func title(forBurialId burialId: String) -> String {
        guard let item = burials.first(where: { return $0.id == burialId }) else {
            return burialId
        }
        return item.veteranNames.isBlank ? item.type.titleText : item.veteranNames
    }

    var previewStops: [MapRouteStop] {
        let burialsById = Dictionary(burials.map { return ($0.id, $0.burial) }) { first, _ in return first }
        return form.stops
            .compactMap { return burialsById[$0.burialId] }
            .enumerated()
            .map { index, burial in
                return MapRouteStop(index: index, number: index + 1, latitude: burial.latitude, longitude: burial.longitude)
            }
    }
}
