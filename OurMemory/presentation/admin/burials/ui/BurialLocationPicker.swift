import SwiftUI

struct BurialLocationPicker: View {
    private static let mapHeight: CGFloat = 240
    private static let zoom: Float = 18

    let latitude: Double?
    let longitude: Double?
    let onPointPicked: (Double, Double) -> Void
    @State private var camera: MapCamera?
    @State private var isPermissionDenied = false
    @State private var locationPermission = LocationPermission()
    @State private var locationProvider = CurrentLocationProvider()

    var body: some View {
        return YandexMapView(content: MapContent(markers: marker), camera: camera, onMapTap: onPointPicked)
            .frame(height: Self.mapHeight)
            .listRowInsets(EdgeInsets())
            .overlay(alignment: .bottomTrailing) {
                Button(action: requestLocation) {
                    Image(systemName: "location.fill")
                        .padding(Spacing.l)
                        .background(.regularMaterial, in: Circle())
                }
                .buttonStyle(.plain)
                .foregroundStyle(Palette.primary)
                .padding(Spacing.l)
                .accessibilityLabel("my_location")
            }
            .alert("allow_location_access_msg", isPresented: $isPermissionDenied) {
                Button("done", role: .cancel) {}
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
            guard let coordinate = await locationProvider.currentCoordinate() else {
                return
            }
            onPointPicked(coordinate.latitude, coordinate.longitude)
            camera = MapCamera(latitude: coordinate.latitude, longitude: coordinate.longitude, zoom: Self.zoom)
        }
    }
}
