import SwiftUI

struct MapPreview: View {
    let latitude: Double
    let longitude: Double
    let zoom: Float

    var body: some View {
        return YandexMapView(
            content: MapContent(
                markers: [MapMarker(id: "", latitude: latitude, longitude: longitude)],
                isInteractive: false
            ),
            camera: MapCamera(latitude: latitude, longitude: longitude, zoom: zoom)
        )
        .allowsHitTesting(false)
    }
}
