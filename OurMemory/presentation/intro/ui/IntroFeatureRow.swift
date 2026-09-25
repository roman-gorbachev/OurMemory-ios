import SwiftUI

struct IntroFeatureRow: View {
    private static let iconWidth: CGFloat = 40

    let systemImage: String
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey

    var body: some View {
        return HStack(alignment: .top, spacing: Spacing.xl) {
            Image(systemName: systemImage)
                .font(.title)
                .foregroundStyle(Palette.primary)
                .frame(width: Self.iconWidth)
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(title)
                    .appStyle(.headline)
                Text(subtitle)
                    .appStyle(.subheadline)
                    .foregroundStyle(Palette.onSurfaceVariant)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    IntroFeatureRow(systemImage: "flame", title: "candle_and_favorites", subtitle: "candle_and_favorites_msg")
        .padding()
}
