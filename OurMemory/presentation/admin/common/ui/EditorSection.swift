import SwiftUI

struct EditorSection<Content: View>: View {
    let title: LocalizedStringKey
    @ViewBuilder var content: () -> Content

    var body: some View {
        return VStack(alignment: .leading, spacing: Spacing.l) {
            Text(title)
                .appStyle(.titleLarge, weight: .bold)
                .foregroundStyle(Palette.primary)
            content()
        }
    }
}
