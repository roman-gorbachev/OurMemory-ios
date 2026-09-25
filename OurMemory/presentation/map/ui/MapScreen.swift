import SwiftUI

struct MapScreen: View {
    let data: MapUiData
    let initialCamera: MapCamera
    let bottomInset: CGFloat
    let onAction: (MapUserAction) -> Void
    let onBack: (() -> Void)?
    let onVeteranOpen: (String) -> Void
    let onTourOpen: (String) -> Void
    @State private var isSatellite = false
    @State private var isToursPresented = false
    @State private var locationRequest = 0
    @State private var showsUserLocation = false
    @State private var isLocationDenied = false
    @State private var locationPermission = LocationPermission()

    var body: some View {
        return ZStack {
            YandexMapView(
                content: MapContent(markers: data.markers, clustersMarkers: true, isSatellite: isSatellite),
                camera: initialCamera,
                locationRequest: locationRequest,
                showsUserLocation: showsUserLocation,
                onMarkerTap: { onAction(.markerTapped($0)) }
            )
            .ignoresSafeArea()
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    if let onBack {
                        CircleIconButton(systemImage: "chevron.left", accessibilityLabel: "back", action: onBack)
                            .padding(.leading, Spacing.l)
                    }
                    CategoryFilter(
                        checkedWar: data.checkedWar,
                        checkedArt: data.checkedArt,
                        onWarChange: { onAction(.warToggled($0)) },
                        onArtChange: { onAction(.artToggled($0)) }
                    )
                }
                .padding(.top, Spacing.m)
                Spacer()
                HStack(alignment: .bottom) {
                    if !data.tours.isEmpty {
                        toursButton
                    }
                    Spacer()
                    MapControls(isSatellite: isSatellite, onMapTypeTap: { isSatellite.toggle() }, onMyLocationTap: showMyLocation)
                }
                .padding(Spacing.xl)
                .padding(.bottom, bottomInset)
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
        }
        .alert("allow_location_access_msg", isPresented: $isLocationDenied) {
            Button("done", role: .cancel) {}
        }
    }

    private var toursButton: some View {
        return Button {
            isToursPresented = true
        } label: {
            Label("tours", systemImage: "figure.walk")
                .appStyle(.labelLarge, weight: .bold)
                .foregroundStyle(Palette.primary)
                .padding(.horizontal, Spacing.xl)
                .padding(.vertical, Spacing.xl)
                .background(RoundedRectangle(cornerRadius: CornerRadius.extraLarge).fill(Palette.surface))
                .shadow(color: Palette.shadow, radius: Shadow.mediumRadius, y: Shadow.offsetY)
        }
        .buttonStyle(.plain)
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
