import SwiftUI

struct SubmissionScreen: View {
    private static let memoriesMinLines = 5

    let data: SubmissionUiData
    let onAction: (SubmissionUserAction) -> Void

    var body: some View {
        let isEditable = data.status != .sending
        return Form {
            Section {
                VStack(alignment: .leading, spacing: Spacing.s) {
                    if !data.veteranName.isBlank {
                        Text(verbatim: data.veteranName)
                            .appStyle(.headline)
                    }
                    Text("share_materials_msg")
                        .appStyle(.subheadline)
                        .foregroundStyle(Palette.onSurfaceVariant)
                }
            }
            Section {
                TextField("memories", text: Binding(get: { return data.text }, set: { onAction(.textChanged($0)) }), axis: .vertical)
                    .lineLimit(Self.memoriesMinLines...)
            } footer: {
                if data.hasTextProfanity {
                    Text("remove_offensive_words_msg").foregroundStyle(Palette.error)
                }
            }
            Section {
                TextField("your_name_and_contact", text: Binding(get: { return data.contact }, set: { onAction(.contactChanged($0)) }))
                    .textContentType(.name)
            } footer: {
                if data.hasContactProfanity {
                    Text("remove_offensive_words_msg").foregroundStyle(Palette.error)
                }
            }
            Section {
                PhotoPickerRow(
                    photos: data.photos,
                    checkingPhotosCount: data.checkingPhotosCount,
                    canAddPhotos: data.canAddPhotos,
                    remainingSlots: data.remainingPhotoSlots,
                    onPicked: { onAction(.photosPicked($0)) },
                    onRemove: { onAction(.photoRemoved($0)) }
                )
                .listRowInsets(EdgeInsets(top: Spacing.l, leading: 0, bottom: Spacing.l, trailing: 0))
            } header: {
                Text(verbatim: L10n.format("photos_count_of_max", data.photos.count, SubmissionUiData.maxPhotos))
            } footer: {
                if let rejection = data.photoRejection {
                    Text(rejection.rejectionKey).foregroundStyle(Palette.error)
                }
            }
            Section {
                Toggle("consent_to_contact_msg", isOn: Binding(get: { return data.hasConsent }, set: { onAction(.consentChanged($0)) }))
                    .appStyle(.subheadline)
            } footer: {
                if data.status == .failed {
                    Text("failed_to_send_msg").foregroundStyle(Palette.error)
                }
            }
        }
        .disabled(!isEditable)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                if data.status == .sending {
                    ProgressView()
                } else {
                    Button("send") { onAction(.send) }
                        .disabled(!data.canSend)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SubmissionScreen(data: SubmissionUiData(veteranName: "Иванов Иван"), onAction: { _ in })
    }
}
