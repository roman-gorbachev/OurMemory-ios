import SwiftUI

struct SettingsGroup<Content: View>: View {
    let title: LocalizedStringKey
    @ViewBuilder var content: () -> Content

    var body: some View {
        return VStack(alignment: .leading, spacing: Spacing.m) {
            GroupTitle(text: title)
            VStack(spacing: 0) {
                content()
            }
            .background(RoundedRectangle(cornerRadius: CornerRadius.group).fill(Palette.containerLow))
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.group))
        }
    }
}

#Preview {
    SettingsGroup(title: "mine") {
        SettingRow(systemImage: "heart", title: "favorites") {}
    }
    .padding()
}
