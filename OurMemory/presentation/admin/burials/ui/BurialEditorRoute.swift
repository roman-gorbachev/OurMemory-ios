import SwiftUI

struct BurialEditorRoute: View {
    private static let photoHeight: CGFloat = 180
    private static let descriptionLines = 2

    @State private var viewModel: BurialEditorViewModel
    let onClose: () -> Void

    init(viewModel: BurialEditorViewModel, onClose: @escaping () -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onClose = onClose
    }

    var body: some View {
        return content
            .navigationTitle(isNew ? "new_burial_place" : "burial_place")
            .navigationBarTitleDisplayMode(.inline)
            .task { await viewModel.load() }
    }

    private var isNew: Bool {
        if case .editing(let data) = viewModel.burialEditorUiState {
            return data.isNew
        }
        return false
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.burialEditorUiState {
        case .loading:
            LoadingView()
        case .error:
            ErrorView()
        case .editing(let data):
            form(data)
                .toolbar {
                    EditorToolbar(status: data.status, canSave: data.canSave) { viewModel.onAction(.save) }
                }
                .editorFailureAlert(data.status.failure, uid: data.currentUid) { viewModel.onAction(.failureDismissed) }
                .onChange(of: data.status.isClosed) { _, isClosed in
                    if isClosed {
                        onClose()
                    }
                }
        }
    }

    private func form(_ data: BurialEditorUiData) -> some View {
        let form = data.form
        let onAction = viewModel.onAction
        return Form {
            Section {
                Picker("burial_place", selection: Binding(get: { return form.type }, set: { onAction(.typeChanged($0)) })) {
                    ForEach(BurialType.allCases, id: \.self) { Text($0.titleKey).tag($0) }
                }
                .pickerStyle(.segmented)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            }
            Section {
                LabeledContent("section") {
                    TextField("section", text: Binding(get: { return form.section }, set: { onAction(.sectionChanged($0)) }))
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
                LabeledContent("row") {
                    TextField("row", text: Binding(get: { return form.row }, set: { onAction(.rowChanged($0)) }))
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
                LabeledContent("place") {
                    TextField("place", text: Binding(get: { return form.place }, set: { onAction(.placeChanged($0)) }))
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
            }
            Section("description") {
                TextField("description", text: Binding(get: { return form.description }, set: { onAction(.descriptionChanged($0)) }), axis: .vertical)
                    .lineLimit(Self.descriptionLines...)
            }
            Section {
                if !form.photo.isBlank {
                    RemoteImage(url: form.photo)
                        .frame(height: Self.photoHeight)
                        .clipped()
                        .listRowInsets(EdgeInsets())
                }
                PhotoPickButton(title: "add_photo") { onAction(.photoPicked($0)) }
                if !form.photo.isBlank {
                    Button("remove_photo", role: .destructive) { onAction(.photoRemoved) }
                }
            } footer: {
                EditorStatusFooter(status: data.status)
            }
            Section {
                BurialLocationPicker(latitude: form.latitudeValue, longitude: form.longitudeValue) {
                    onAction(.pointPicked(latitude: $0, longitude: $1))
                }
                LabeledContent("latitude") {
                    TextField("latitude", text: Binding(get: { return form.latitude }, set: { onAction(.latitudeChanged($0)) }))
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(form.latitudeValue == nil ? Palette.error : Palette.onSurface)
                }
                LabeledContent("longitude") {
                    TextField("longitude", text: Binding(get: { return form.longitude }, set: { onAction(.longitudeChanged($0)) }))
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .foregroundStyle(form.longitudeValue == nil ? Palette.error : Palette.onSurface)
                }
            } header: {
                Text("locationHeader")
            } footer: {
                Text("tap_map_to_move_marker_msg")
            }
        }
        .disabled(data.status.isSaving)
    }
}
