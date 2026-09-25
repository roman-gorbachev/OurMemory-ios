import SwiftUI

struct BurialLocationPicker: View {
    private static let mapHeight: CGFloat = 260
    private static let zoom: Float = 18

    let latitude: Double?
    let longitude: Double?
    let onPointPicked: (Double, Double) -> Void
    @State private var camera: MapCamera?
    @State private var isPermissionDenied = false
    @State private var locationPermission = LocationPermission()
    @State private var locationProvider = CurrentLocationProvider()

    var body: some View {
        return VStack(alignment: .leading, spacing: Spacing.m) {
            YandexMapView(
                content: MapContent(markers: marker),
                camera: camera,
                onMapTap: onPointPicked
            )
            .frame(height: Self.mapHeight)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.large))
            Text("tap_map_to_move_marker_msg")
                .appStyle(.bodySmall)
                .foregroundStyle(Palette.onSurfaceVariant)
            AppButton(title: "my_location", systemImage: "location", kind: .outlined, action: requestLocation)
            if isPermissionDenied {
                Text("allow_location_access_msg")
                    .appStyle(.bodySmall)
                    .foregroundStyle(Palette.error)
            }
        }
        .onAppear {
            if camera == nil {
                camera = MapCamera(
                    latitude: latitude ?? CemeteryLocation.latitude,
                    longitude: longitude ?? CemeteryLocation.longitude,
                    zoom: Self.zoom
                )
            }
        }
    }

    private var marker: [MapMarker] {
        guard let latitude, let longitude else {
            return []
        }
        return [MapMarker(id: "", latitude: latitude, longitude: longitude)]
    }

    private func requestLocation() {
        Task {
            guard await locationPermission.request() else {
                isPermissionDenied = true
                return
            }
            isPermissionDenied = false
            guard let coordinate = await locationProvider.currentCoordinate() else {
                return
            }
            onPointPicked(coordinate.latitude, coordinate.longitude)
            camera = MapCamera(latitude: coordinate.latitude, longitude: coordinate.longitude, zoom: Self.zoom)
        }
    }
}
