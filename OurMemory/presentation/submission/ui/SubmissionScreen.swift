import SwiftUI

struct SubmissionScreen: View {
    private static let memoriesMinLines = 5

    let data: SubmissionUiData
    let onAction: (SubmissionUserAction) -> Void

    var body: some View {
        let isEditable = data.status != .sending
        return ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                VStack(alignment: .leading, spacing: Spacing.m) {
                    if !data.veteranName.isBlank {
                        Text(verbatim: data.veteranName)
                            .appStyle(.titleLarge, weight: .bold)
                            .foregroundStyle(Palette.primary)
                    }
                    Text("share_materials_msg")
                        .appStyle(.bodyLarge)
                        .foregroundStyle(Palette.onSurface)
                }
                .padding(.horizontal, Spacing.screen)
                VStack(spacing: Spacing.xl) {
                    AppTextField(
                        label: "memories",
                        text: Binding(get: { return data.text }, set: { onAction(.textChanged($0)) }),
                        axis: .vertical,
                        minLines: Self.memoriesMinLines,
                        isError: data.hasTextProfanity,
                        supportingText: data.hasTextProfanity ? "remove_offensive_words_msg" : nil
                    )
                    AppTextField(
                        label: "your_name_and_contact",
                        text: Binding(get: { return data.contact }, set: { onAction(.contactChanged($0)) }),
                        isError: data.hasContactProfanity,
                        supportingText: data.hasContactProfanity ? "remove_offensive_words_msg" : nil
                    )
                }
                .disabled(!isEditable)
                .padding(.horizontal, Spacing.screen)
                photosSection
                CheckboxRow(title: "consent_to_contact_msg", isChecked: data.hasConsent) {
                    onAction(.consentChanged(!data.hasConsent))
                }
                .disabled(!isEditable)
                .padding(.horizontal, Spacing.screen)
                if data.status == .failed {
                    Text("failed_to_send_msg")
                        .appStyle(.bodyMedium)
                        .foregroundStyle(Palette.error)
                        .padding(.horizontal, Spacing.screen)
                }
                AppButton(title: "send", isLoading: data.status == .sending) { onAction(.send) }
                    .disabled(!data.canSend)
                    .padding(.horizontal, Spacing.screen)
            }
            .padding(.vertical, Spacing.xl)
        }
        .scrollDismissesKeyboard(.interactively)
    }

    private var photosSection: some View {
        return VStack(alignment: .leading, spacing: Spacing.m) {
            Text(verbatim: L10n.format("photos_count_of_max", data.photos.count, SubmissionUiData.maxPhotos))
                .appStyle(.labelLarge)
                .foregroundStyle(Palette.onSurfaceVariant)
                .padding(.horizontal, Spacing.screen)
            PhotoPickerRow(
                photos: data.photos,
                checkingPhotosCount: data.checkingPhotosCount,
                canAddPhotos: data.canAddPhotos,
                remainingSlots: data.remainingPhotoSlots,
                onPicked: { onAction(.photosPicked($0)) },
                onRemove: { onAction(.photoRemoved($0)) }
            )
            if let rejection = data.photoRejection {
                Text(rejection.rejectionKey)
                    .appStyle(.bodyMedium)
                    .foregroundStyle(Palette.error)
                    .padding(.horizontal, Spacing.screen)
            }
        }
    }
}

#Preview {
    SubmissionScreen(data: SubmissionUiData(veteranName: "Иванов Иван"), onAction: { _ in })
}
