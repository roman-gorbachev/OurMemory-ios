import SwiftUI

struct DisclosureButton<Label: View>: View {
    let action: () -> Void
    @ViewBuilder var label: () -> Label

    var body: some View {
        return Button(action: action) {
            HStack {
                label()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "chevron.right")
                    .appStyle(.footnote, weight: .semibold)
                    .foregroundStyle(Palette.tertiaryLabel)
            }
            .foregroundStyle(Palette.onSurface)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
