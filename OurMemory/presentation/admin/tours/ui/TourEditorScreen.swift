import SwiftUI

struct TourEditorScreen: View {
    private static let previewHeight: CGFloat = 240
    private static let descriptionLines = 2
    private static let stopTextLines = 2

    let data: TourEditorUiData
    let onAction: (TourEditorUserAction) -> Void
    @State private var isChoosingStop = false

    var body: some View {
        let form = data.form
        return Form {
            Section {
                TextField("title", text: Binding(get: { return form.title }, set: { onAction(.titleChanged($0)) }))
                TextField(
                    "description",
                    text: Binding(get: { return form.description }, set: { onAction(.descriptionChanged($0)) }),
                    axis: .vertical
                )
                .lineLimit(Self.descriptionLines...)
            }
            if !data.previewStops.isEmpty {
                Section {
                    YandexMapView(content: MapContent(routeStops: data.previewStops, isInteractive: false))
                        .frame(height: Self.previewHeight)
                        .listRowInsets(EdgeInsets())
                }
            }
            Section("stops") {
                ForEach(Array(form.stops.enumerated()), id: \.element.id) { index, stop in
                    stopRow(stop, number: index + 1)
                }
                .onMove { onAction(.stopsMoved($0, $1)) }
                .onDelete { onAction(.stopsRemoved($0)) }
                Button {
                    isChoosingStop = true
                } label: {
                    Label("add_stop", systemImage: "plus.circle.fill")
                }
            }
            .disabled(data.status.isBusy)
            if data.status.failure != nil || data.status.isUploading {
                Section {
                    EditorStatusFooter(status: data.status)
                }
            }
            if !data.isNew {
                DeleteSection(message: "delete_tour_msg", isDisabled: data.status.isBusy) { onAction(.delete) }
            }
        }
        .environment(\.editMode, .constant(.active))
        .sheet(isPresented: $isChoosingStop) {
            BurialChoiceSheet(burials: data.burials) { burialId in
                isChoosingStop = false
                onAction(.stopAdded(burialId: burialId))
            }
        }
    }

    private func stopRow(_ stop: TourStopForm, number: Int) -> some View {
        return VStack(alignment: .leading, spacing: Spacing.m) {
            Text(verbatim: "\(number). \(data.title(forBurialId: stop.burialId))")
                .font(.headline)
                .foregroundStyle(Palette.primary)
            TextField(
                "stop_text",
                text: Binding(get: { return stop.text }, set: { onAction(.stopTextChanged(stop.id, $0)) }),
                axis: .vertical
            )
            .lineLimit(Self.stopTextLines...)
            AudioAttachmentRow(
                audioUrl: stop.audioUrl,
                onPicked: { onAction(.stopAudioPicked(stop.id, $0)) },
                onRemove: { onAction(.stopAudioRemoved(stop.id)) }
            )
        }
        .padding(.vertical, Spacing.xs)
    }
}
