import SwiftUI
import YandexMapsMobile

struct YandexMapView: UIViewRepresentable {
    var content = MapContent()
    var camera: MapCamera?
    var locationRequest = 0
    var showsUserLocation = false
    var logoInsets = EdgeInsets()
    var onMarkerTap: ((String) -> Void)?
    var onStopTap: ((Int) -> Void)?
    var onMapTap: ((Double, Double) -> Void)?
    @Environment(\.colorScheme) private var colorScheme

    func makeUIView(context: Context) -> YMKMapView {
        let mapView = YMKMapView(frame: .zero, vulkanPreferred: Self.isSimulator) ?? YMKMapView()
        context.coordinator.attach(to: mapView)
        return mapView
    }

    private static var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }

    func updateUIView(_ mapView: YMKMapView, context: Context) {
        let coordinator = context.coordinator
        coordinator.onMarkerTap = onMarkerTap
        coordinator.onStopTap = onStopTap
        coordinator.onMapTap = onMapTap
        coordinator.apply(content: content, camera: camera, isNightMode: colorScheme == .dark, locationRequest: locationRequest)
        coordinator.showUserLocationLayerIfAllowed(showsUserLocation)
        coordinator.applyLogoInsets(logoInsets)
    }

    func makeCoordinator() -> YandexMapCoordinator {
        return YandexMapCoordinator()
    }
}
