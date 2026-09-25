import SwiftUI

struct SectionTitle: View {
    let text: LocalizedStringKey

    var body: some View {
        return Text(text)
            .appStyle(.title3, weight: .bold)
            .foregroundStyle(Palette.onSurface)
            .padding(.horizontal, Spacing.screen)
            .padding(.bottom, Spacing.m)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    SectionTitle(text: "biography")
}
