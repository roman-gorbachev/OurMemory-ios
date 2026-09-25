import SwiftUI

struct TourScreen: View {
    private static let stopZoom: Float = 19
    private static let headerId = "header"

    let data: TourUiData
    let playbackState: AudioPlaybackState
    let onAction: (TourUserAction) -> Void

    var body: some View {
        return VStack(spacing: 0) {
            YandexMapView(
                content: MapContent(routeStops: data.stops.enumerated().map { index, stop in
                    return MapRouteStop(index: index, number: stop.number, latitude: stop.burial.latitude, longitude: stop.burial.longitude)
                }),
                camera: selectedCamera,
                onStopTap: { onAction(.stopTapped($0)) }
            )
            .ignoresSafeArea(edges: .top)
            .frame(maxHeight: .infinity)
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: Spacing.m) {
                        header.id(Self.headerId)
                        ForEach(Array(data.stops.enumerated()), id: \.element.id) { index, stop in
                            TourStopRow(
                                stop: stop,
                                isSelected: index == data.selectedStopIndex,
                                isPlaying: playbackState.isPlaying && playbackState.currentAudio?.id == stop.audio?.id,
                                isVisited: data.visitedStops.contains(index),
                                onTap: { onAction(.stopTapped(index)) },
                                onAudioTap: { onAction(.stopAudioTapped(index)) },
                                onVisitedToggle: { onAction(.stopVisitedToggled(index)) }
                            )
                            .id(index)
                        }
                    }
                    .padding(Spacing.xl)
                }
                .frame(maxHeight: .infinity)
                .onChange(of: data.selectedStopIndex, initial: true) { _, index in
                    guard let index else {
                        return
                    }
                    withAnimation {
                        proxy.scrollTo(index, anchor: .top)
                    }
                }
            }
        }
    }

    private var selectedCamera: MapCamera? {
        guard let index = data.selectedStopIndex, data.stops.indices.contains(index) else {
            return nil
        }
        let burial = data.stops[index].burial
        return MapCamera(latitude: burial.latitude, longitude: burial.longitude, zoom: Self.stopZoom, isAnimated: true)
    }

    private var header: some View {
        return VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(verbatim: data.title)
                .appStyle(.headlineSmall, weight: .bold)
                .foregroundStyle(Palette.onSurface)
            if !data.description.isBlank {
                Text(verbatim: data.description)
                    .appStyle(.bodyMedium)
                    .foregroundStyle(Palette.onSurfaceVariant)
            }
            if !data.visitedStops.isEmpty {
                HStack {
                    Text(verbatim: L10n.format(
                        "visited_of_total",
                        data.visitedStops.filter { return data.stops.indices.contains($0) }.count,
                        data.stops.count
                    ))
                    .appStyle(.labelLarge, weight: .bold)
                    .foregroundStyle(Palette.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Button("start_over") { onAction(.resetProgress) }
                        .appStyle(.labelLarge, weight: .semibold)
                        .foregroundStyle(Palette.primary)
                }
                .padding(.top, Spacing.m)
            }
        }
        .padding(.bottom, Spacing.m)
    }
}
