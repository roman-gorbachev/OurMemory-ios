import SwiftUI

struct BurialEditorScreen: View {
    private static let photoHeight: CGFloat = 180
    private static let descriptionLines = 2

    let data: BurialEditorUiData
    let onAction: (BurialEditorUserAction) -> Void

    var body: some View {
        let form = data.form
        return ScrollView {
            VStack(alignment: .leading, spacing: Spacing.l) {
                HStack(spacing: Spacing.m) {
                    ForEach(BurialType.allCases, id: \.self) { type in
                        FilterToggle(title: type.titleKey, isSelected: form.type == type) { onAction(.typeChanged(type)) }
                    }
                }
                HStack(spacing: Spacing.m) {
                    AppTextField(label: "section", text: binding(form.section) { .sectionChanged($0) }, keyboard: .numberPad)
                    AppTextField(label: "row", text: binding(form.row) { .rowChanged($0) }, keyboard: .numberPad)
                    AppTextField(label: "place", text: binding(form.place) { .placeChanged($0) }, keyboard: .numberPad)
                }
                AppTextField(
                    label: "description",
                    text: binding(form.description) { .descriptionChanged($0) },
                    axis: .vertical,
                    minLines: Self.descriptionLines
                )
                if !form.photo.isBlank {
                    RemoteImage(url: form.photo)
                        .frame(maxWidth: .infinity)
                        .frame(height: Self.photoHeight)
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.large))
                }
                HStack(spacing: Spacing.m) {
                    PhotoPickButton(title: "add_photo") { onAction(.photoPicked($0)) }
                    if !form.photo.isBlank {
                        Button("delete") { onAction(.photoRemoved) }
                            .appStyle(.labelLarge, weight: .semibold)
                            .foregroundStyle(Palette.error)
                    }
                }
                .disabled(data.status.isBusy)
                BurialLocationPicker(latitude: form.latitudeValue, longitude: form.longitudeValue) {
                    onAction(.pointPicked(latitude: $0, longitude: $1))
                }
                HStack(spacing: Spacing.m) {
                    AppTextField(
                        label: "latitude",
                        text: binding(form.latitude) { .latitudeChanged($0) },
                        isError: form.latitudeValue == nil,
                        keyboard: .decimalPad
                    )
                    AppTextField(
                        label: "longitude",
                        text: binding(form.longitude) { .longitudeChanged($0) },
                        isError: form.longitudeValue == nil,
                        keyboard: .decimalPad
                    )
                }
                EditorFooter(status: data.status, canSave: data.canSave, deleteMessage: nil, onSave: { onAction(.save) }, onDelete: {})
            }
            .padding(Spacing.screen)
            .padding(.bottom, Spacing.xxxl)
        }
        .scrollDismissesKeyboard(.interactively)
    }

    private func binding(_ value: String, action: @escaping (String) -> BurialEditorUserAction) -> Binding<String> {
        return Binding(get: { return value }, set: { onAction(action($0)) })
    }
}
