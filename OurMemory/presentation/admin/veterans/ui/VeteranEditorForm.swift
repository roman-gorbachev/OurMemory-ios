import SwiftUI

struct VeteranEditorForm: View {
    private static let portraitSize: CGFloat = 72
    private static let shortTextLines = 2
    private static let longTextLines = 4
    private static let rewardIconSize: CGFloat = 28
    private static let inactiveOpacity = 0.35

    let data: VeteranEditorUiData
    let onAction: (VeteranEditorUserAction) -> Void

    var body: some View {
        let form = data.form
        let text = form.text
        return Form {
            ContentLanguageSection(language: form.language) { onAction(.languageChanged($0)) }
            Section {
                HStack(spacing: Spacing.xl) {
                    PortraitImage(url: form.portrait)
                        .frame(width: Self.portraitSize, height: Self.portraitSize)
                        .clipShape(Circle())
                    PhotoPickButton(title: "choose_portrait", systemImage: "person.crop.circle.badge.plus") {
                        onAction(.portraitPicked($0))
                    }
                }
                TextField(
                    "full_name",
                    text: Binding(get: { return text.name }, set: { onAction(.nameChanged($0)) }),
                    prompt: OriginalTextPrompt.prompt(form.name, language: form.language)
                )
                .foregroundStyle(form.isNameValid ? Palette.onSurface : Palette.error)
                TextField("years_of_life", text: Binding(get: { return form.years }, set: { onAction(.yearsChanged($0)) }))
                Picker("veteran", selection: Binding(get: { return form.category }, set: { onAction(.categoryChanged($0)) })) {
                    ForEach(VeteranCategory.allCases, id: \.self) { Text($0.titleKey).tag($0) }
                }
                .pickerStyle(.segmented)
            }
            Section("short_info") {
                TextField(
                    "short_info",
                    text: Binding(get: { return text.baseInfo }, set: { onAction(.baseInfoChanged($0)) }),
                    prompt: OriginalTextPrompt.prompt(form.baseInfo, language: form.language),
                    axis: .vertical
                )
                    .lineLimit(Self.shortTextLines...)
            }
            Section("main_text") {
                TextField(
                    "main_text",
                    text: Binding(get: { return text.allInfo }, set: { onAction(.allInfoChanged($0)) }),
                    prompt: OriginalTextPrompt.prompt(form.allInfo, language: form.language),
                    axis: .vertical
                )
                    .lineLimit(Self.longTextLines...)
            }
            Section {
                IsoDateRow(title: "date_of_birth", date: form.birthDate) { onAction(.birthDateChanged($0)) }
                IsoDateRow(title: "date_of_death", date: form.deathDate) { onAction(.deathDateChanged($0)) }
                Picker("burial_place", selection: Binding(get: { return form.burialId }, set: { onAction(.burialChanged($0)) })) {
                    Text("not_specified").tag("")
                    ForEach(data.burials) { burial in
                        Text(verbatim: label(for: burial)).tag(burial.id)
                    }
                }
            }
            Section("awards") {
                ForEach(Reward.allCases, id: \.self) { reward in
                    rewardRow(reward, count: form.rewards[reward] ?? 0)
                }
            }
            Section("listen_to_biography") {
                AudioAttachmentRow(
                    audioUrl: form.audioUrl,
                    onPicked: { onAction(.audioPicked($0)) },
                    onRemove: { onAction(.audioRemoved) }
                )
            }
            Section {
                ForEach(text.entries) { entry in
                    InfoEntryRow(entry: entry) { onAction(.entryChanged($0)) }
                }
                .onMove { offsets, destination in
                    guard let source = offsets.first else {
                        return
                    }
                    onAction(.entryMoved(text.entries[source].id, offset: destination > source ? destination - source - 1 : destination - source))
                }
                .onDelete { offsets in
                    offsets.map { return text.entries[$0].id }.forEach { onAction(.entryRemoved($0)) }
                }
                if form.language != .russian, text.entries.isEmpty, !form.entries.isEmpty {
                    Button {
                        onAction(.paragraphsCopiedFromOriginal)
                    } label: {
                        Label("copy_paragraphs_from_russian", systemImage: "doc.on.doc")
                    }
                }
                Button {
                    onAction(.paragraphAdded)
                } label: {
                    Label("add_paragraph", systemImage: "text.badge.plus")
                }
                PhotoPickButton(title: "add_photo") { onAction(.mediaPicked($0)) }
            } header: {
                Text("biography_and_media")
            } footer: {
                EditorStatusFooter(status: data.status)
            }
            if !data.isNew {
                DeleteSection(message: "delete_veteran_msg", isDisabled: data.status.isBusy) { onAction(.delete) }
            }
        }
        .disabled(data.status.isSaving)
    }

    private func rewardRow(_ reward: Reward, count: Int) -> some View {
        return Stepper(
            value: Binding(get: { return count }, set: { onAction(.rewardCountChanged(reward, delta: $0 - count)) }),
            in: 0...Int.max
        ) {
            HStack(spacing: Spacing.m) {
                Image(reward.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Self.rewardIconSize, height: Self.rewardIconSize)
                    .opacity(count > 0 ? 1 : Self.inactiveOpacity)
                VStack(alignment: .leading) {
                    Text(reward.nameKey).appStyle(.subheadline)
                    if count > 0 {
                        Text(verbatim: L10n.format("times_count", count))
                            .appStyle(.caption, weight: .semibold)
                            .foregroundStyle(Palette.primary)
                    }
                }
            }
        }
    }

    private func label(for burial: BurialUi) -> String {
        return burial.hasPlotNumber ? L10n.format("section_row_place_msg", burial.section, burial.row, burial.place) : burial.id
    }
}
