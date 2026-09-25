import SwiftUI

struct MapScreen: View {
    let data: MapUiData
    let initialCamera: MapCamera
    let onAction: (MapUserAction) -> Void
    let onVeteranOpen: (String) -> Void
    let onTourOpen: (String) -> Void
    @State private var isSatellite = false
    @State private var isToursPresented = false
    @State private var locationRequest = 0
    @State private var showsUserLocation = false
    @State private var isLocationDenied = false
    @State private var locationPermission = LocationPermission()

    var body: some View {
        return YandexMapView(
            content: MapContent(markers: data.markers, clustersMarkers: true, isSatellite: isSatellite),
            camera: initialCamera,
            locationRequest: locationRequest,
            showsUserLocation: showsUserLocation,
            onMarkerTap: { onAction(.markerTapped($0)) }
        )
        .ignoresSafeArea(edges: [.top, .horizontal])
        .overlay(alignment: .topTrailing) {
            MapControls(
                checkedWar: data.checkedWar,
                checkedArt: data.checkedArt,
                isSatellite: isSatellite,
                onWarChange: { onAction(.warToggled($0)) },
                onArtChange: { onAction(.artToggled($0)) },
                onMapTypeTap: { isSatellite.toggle() },
                onMyLocationTap: showMyLocation
            )
            .padding(Spacing.l)
        }
        .overlay(alignment: .bottom) {
            if !data.tours.isEmpty {
                Button {
                    isToursPresented = true
                } label: {
                    Label("tours", systemImage: "figure.walk")
                        .appStyle(.headline)
                        .padding(.horizontal, Spacing.xl)
                        .padding(.vertical, Spacing.l)
                }
                .buttonStyle(.plain)
                .foregroundStyle(Palette.primary)
                .background(.regularMaterial, in: Capsule())
                .shadow(color: Palette.shadow, radius: Shadow.largeRadius, y: Shadow.offsetY)
                .padding(.bottom, Spacing.xl)
            }
        }
        .onAppear { showsUserLocation = locationPermission.isGranted }
        .sheet(isPresented: $isToursPresented) {
            ToursSheet(tours: data.tours) { tourId in
                isToursPresented = false
                onTourOpen(tourId)
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .sheet(item: Binding(get: { return data.selectedBurial }, set: { if $0 == nil { onAction(.sheetDismissed) } })) { details in
            BurialSheet(details: details) { veteranId in
                onAction(.sheetDismissed)
                onVeteranOpen(veteranId)
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
            .presentationBackgroundInteraction(.enabled(upThrough: .medium))
        }
        .alert("allow_location_access_msg", isPresented: $isLocationDenied) {
            Button("done", role: .cancel) {}
        }
    }

    private func showMyLocation() {
        Task {
            if await locationPermission.request() {
                showsUserLocation = true
                locationRequest += 1
            } else {
                isLocationDenied = true
            }
        }
    }
}
