import SwiftUI
import YandexMapsMobile

struct YandexMapView: UIViewRepresentable {
    var content = MapContent()
    var camera: MapCamera?
    var locationRequest = 0
    var showsUserLocation = false
    var onMarkerTap: ((String) -> Void)?
    var onStopTap: ((Int) -> Void)?
    var onMapTap: ((Double, Double) -> Void)?
    @Environment(\.colorScheme) private var colorScheme

    func makeUIView(context: Context) -> YMKMapView {
        let mapView = YMKMapView(frame: .zero) ?? YMKMapView()
        context.coordinator.attach(to: mapView)
        return mapView
    }

    func updateUIView(_ mapView: YMKMapView, context: Context) {
        let coordinator = context.coordinator
        coordinator.onMarkerTap = onMarkerTap
        coordinator.onStopTap = onStopTap
        coordinator.onMapTap = onMapTap
        coordinator.apply(content: content, camera: camera, isNightMode: colorScheme == .dark, locationRequest: locationRequest)
        coordinator.showUserLocationLayerIfAllowed(showsUserLocation)
    }

    func makeCoordinator() -> YandexMapCoordinator {
        return YandexMapCoordinator()
    }
}
