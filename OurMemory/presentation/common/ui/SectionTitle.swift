import SwiftUI

struct SectionTitle: View {
    let text: LocalizedStringKey

    var body: some View {
        return Text(text)
            .appStyle(.titleLarge, weight: .bold)
            .foregroundStyle(Palette.primary)
            .padding(.horizontal, Spacing.screen)
            .padding(.bottom, Spacing.l)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    SectionTitle(text: "biography")
}
