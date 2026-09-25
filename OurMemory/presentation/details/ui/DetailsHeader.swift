import SwiftUI

struct DetailsHeader: View {
    private static let yearsOpacity = 0.85
    private static let textPadding: CGFloat = 20

    let name: String
    let years: String
    let portrait: String
    let height: CGFloat

    var body: some View {
        return ZStack(alignment: .bottomLeading) {
            Palette.containerHigh
            Color.clear
                .overlay(alignment: .top) {
                    PortraitImage(url: portrait)
                }
                .clipped()
            HeroScrim()
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(verbatim: name)
                    .appStyle(.headlineMedium, weight: .bold)
                    .foregroundStyle(Palette.white)
                if !years.isBlank {
                    Text(verbatim: years)
                        .appStyle(.titleMedium)
                        .foregroundStyle(Palette.white.opacity(Self.yearsOpacity))
                }
            }
            .padding(Self.textPadding)
        }
        .frame(height: height)
        .frame(maxWidth: .infinity)
        .clipped()
    }
}

#Preview {
    DetailsHeader(name: "Иванов Иван", years: "1905–1966", portrait: "", height: 420)
}
