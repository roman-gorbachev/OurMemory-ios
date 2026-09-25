import SwiftUI

struct BurialPicker: View {
    let burials: [BurialUi]
    let selectedId: String
    let onSelect: (String) -> Void

    var body: some View {
        return VStack(alignment: .leading, spacing: Spacing.xs) {
            Text("burial_place")
                .appStyle(.labelMedium)
                .foregroundStyle(Palette.onSurfaceVariant)
            Menu {
                Button("not_specified") { onSelect("") }
                ForEach(burials) { burial in
                    Button {
                        onSelect(burial.id)
                    } label: {
                        Text(verbatim: label(for: burial))
                    }
                }
            } label: {
                HStack {
                    Text(verbatim: selectedLabel)
                        .appStyle(.bodyLarge)
                        .foregroundStyle(Palette.onSurface)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "chevron.up.chevron.down")
                        .foregroundStyle(Palette.onSurfaceVariant)
                }
                .padding(Spacing.l)
                .overlay(RoundedRectangle(cornerRadius: CornerRadius.small).stroke(Palette.outline))
            }
        }
    }

    private var selectedLabel: String {
        if let burial = burials.first(where: { return $0.id == selectedId }) {
            return label(for: burial)
        }
        return selectedId.isBlank ? L10n.string("not_specified") : selectedId
    }

    private func label(for burial: BurialUi) -> String {
        return burial.hasPlotNumber ? L10n.format("section_row_place_msg", burial.section, burial.row, burial.place) : burial.id
    }
}
