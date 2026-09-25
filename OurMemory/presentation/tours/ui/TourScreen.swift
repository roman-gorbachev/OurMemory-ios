import SwiftUI

struct TourScreen: View {
    private static let stopZoom: Float = 19
    private static let mapHeightRatio: CGFloat = 0.42

    let data: TourUiData
    let playbackState: AudioPlaybackState
    let onAction: (TourUserAction) -> Void

    var body: some View {
        return GeometryReader { proxy in
            VStack(spacing: 0) {
                YandexMapView(
                    content: MapContent(routeStops: data.stops.enumerated().map { index, stop in
                        return MapRouteStop(index: index, number: stop.number, latitude: stop.burial.latitude, longitude: stop.burial.longitude)
                    }),
                    camera: selectedCamera,
                    onStopTap: { onAction(.stopTapped($0)) }
                )
                .frame(height: proxy.size.height * Self.mapHeightRatio)
                ScrollViewReader { scroller in
                    List {
                        Section {
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
                                .listRowBackground(index == data.selectedStopIndex ? Palette.primaryContainer : Palette.surface)
                            }
                        } header: {
                            header
                        }
                    }
                    .listStyle(.insetGrouped)
                    .onChange(of: data.selectedStopIndex, initial: true) { _, index in
                        guard let index else {
                            return
                        }
                        withAnimation {
                            scroller.scrollTo(index, anchor: .top)
                        }
                    }
                }
            }
        }
        .navigationTitle(data.title)
        .toolbar {
            if !data.visitedStops.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("start_over", systemImage: "arrow.counterclockwise") { onAction(.resetProgress) }
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
        return VStack(alignment: .leading, spacing: Spacing.s) {
            if !data.description.isBlank {
                Text(verbatim: data.description)
                    .appStyle(.subheadline)
                    .foregroundStyle(Palette.onSurfaceVariant)
                    .textCase(nil)
            }
            if !data.visitedStops.isEmpty {
                let visited = data.visitedStops.filter { return data.stops.indices.contains($0) }.count
                ProgressView(value: Double(visited), total: Double(max(data.stops.count, 1))) {
                    Text(verbatim: L10n.format("visited_of_total", visited, data.stops.count))
                        .appStyle(.caption, weight: .semibold)
                        .textCase(nil)
                }
            }
        }
        .padding(.bottom, Spacing.s)
    }
}
