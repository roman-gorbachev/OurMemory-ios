import SwiftUI

struct VeteranEditorScreen: View {
    private static let portraitSize: CGFloat = 88
    private static let shortTextLines = 2
    private static let longTextLines = 4

    let data: VeteranEditorUiData
    let onAction: (VeteranEditorUserAction) -> Void

    var body: some View {
        let form = data.form
        return ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xxl) {
                mainFields(form)
                VStack(spacing: Spacing.m) {
                    IsoDateField(label: "date_of_birth", date: form.birthDate, isValid: form.isBirthDateValid) {
                        onAction(.birthDateChanged($0))
                    }
                    IsoDateField(label: "date_of_death", date: form.deathDate, isValid: form.isDeathDateValid) {
                        onAction(.deathDateChanged($0))
                    }
                    BurialPicker(burials: data.burials, selectedId: form.burialId) { onAction(.burialChanged($0)) }
                }
                EditorSection(title: "awards") {
                    RewardsEditor(rewards: form.rewards) { onAction(.rewardCountChanged($0, delta: $1)) }
                }
                EditorSection(title: "listen_to_biography") {
                    AudioAttachmentRow(
                        audioUrl: form.audioUrl,
                        onPicked: { onAction(.audioPicked($0)) },
                        onRemove: { onAction(.audioRemoved) }
                    )
                    .disabled(data.status.isBusy)
                }
                EditorSection(title: "biography_and_media") {
                    ForEach(Array(form.entries.enumerated()), id: \.element.id) { index, entry in
                        InfoEntryEditor(
                            entry: entry,
                            canMoveUp: index > 0,
                            canMoveDown: index < form.entries.count - 1,
                            onChange: { onAction(.entryChanged($0)) },
                            onMove: { onAction(.entryMoved(entry.id, offset: $0)) },
                            onRemove: { onAction(.entryRemoved(entry.id)) }
                        )
                    }
                    HStack(spacing: Spacing.m) {
                        AppButton(title: "add_paragraph", kind: .outlined) { onAction(.paragraphAdded) }
                        PhotoPickButton(title: "add_photo") { onAction(.mediaPicked($0)) }
                    }
                    .disabled(data.status.isBusy)
                }
                EditorFooter(
                    status: data.status,
                    canSave: data.canSave,
                    deleteMessage: data.isNew ? nil : "delete_veteran_msg",
                    onSave: { onAction(.save) },
                    onDelete: { onAction(.delete) }
                )
            }
            .padding(Spacing.screen)
            .padding(.bottom, Spacing.xxxl)
        }
        .scrollDismissesKeyboard(.interactively)
    }

    private func mainFields(_ form: VeteranForm) -> some View {
        return VStack(alignment: .leading, spacing: Spacing.l) {
            HStack(spacing: Spacing.xl) {
                PortraitImage(url: form.portrait)
                    .frame(width: Self.portraitSize, height: Self.portraitSize)
                    .clipShape(Circle())
                PhotoPickButton(title: "choose_portrait") { onAction(.portraitPicked($0)) }
                    .fixedSize()
                    .disabled(data.status.isBusy)
            }
            AppTextField(
                label: "full_name",
                text: Binding(get: { return form.name }, set: { onAction(.nameChanged($0)) }),
                isError: !form.isNameValid
            )
            AppTextField(label: "years_of_life", text: Binding(get: { return form.years }, set: { onAction(.yearsChanged($0)) }))
            HStack(spacing: Spacing.m) {
                ForEach(VeteranCategory.allCases, id: \.self) { category in
                    FilterToggle(title: category.titleKey, isSelected: form.category == category) {
                        onAction(.categoryChanged(category))
                    }
                }
            }
            AppTextField(
                label: "short_info",
                text: Binding(get: { return form.baseInfo }, set: { onAction(.baseInfoChanged($0)) }),
                axis: .vertical,
                minLines: Self.shortTextLines
            )
            AppTextField(
                label: "main_text",
                text: Binding(get: { return form.allInfo }, set: { onAction(.allInfoChanged($0)) }),
                axis: .vertical,
                minLines: Self.longTextLines
            )
        }
    }
}
