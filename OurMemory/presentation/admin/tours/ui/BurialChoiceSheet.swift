import SwiftUI

struct BurialChoiceSheet: View {
    let burials: [AdminBurialItemUi]
    let onChoose: (String) -> Void
    @State private var query = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        return NavigationStack {
            List(filtered) { item in
                Button {
                    onChoose(item.id)
                } label: {
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        Text(verbatim: item.veteranNames.isBlank ? item.type.titleText : item.veteranNames)
                            .font(.headline)
                            .foregroundStyle(Palette.onSurface)
                        PlotNumberText(burial: item.burial)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always))
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("add_stop")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("cancel") { dismiss() }
                }
            }
        }
    }

    private var filtered: [AdminBurialItemUi] {
        let text = query.trimmed
        guard !text.isEmpty else {
            return burials
        }
        return burials.filter { item in
            return [item.veteranNames, item.type.titleText, item.burial.section, item.burial.row, item.burial.place]
                .contains { return $0.localizedCaseInsensitiveContains(text) }
        }
    }
}
