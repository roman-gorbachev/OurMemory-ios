import SwiftUI

struct DisclosureRow<Trailing: View>: View {
    let title: LocalizedStringKey
    let systemImage: String
    var color = Palette.primary
    let action: () -> Void
    @ViewBuilder var trailing: () -> Trailing

    var body: some View {
        return Button(action: action) {
            HStack(spacing: Spacing.l) {
                SettingsIcon(systemImage: systemImage, color: color)
                Text(title)
                    .foregroundStyle(Palette.onSurface)
                    .frame(maxWidth: .infinity, alignment: .leading)
                trailing()
                Image(systemName: "chevron.right")
                    .appStyle(.footnote, weight: .semibold)
                    .foregroundStyle(Palette.tertiaryLabel)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

extension DisclosureRow where Trailing == EmptyView {
    init(title: LocalizedStringKey, systemImage: String, color: Color = Palette.primary, action: @escaping () -> Void) {
        self.init(title: title, systemImage: systemImage, color: color, action: action) {
            EmptyView()
        }
    }
}
