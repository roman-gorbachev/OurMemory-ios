import SwiftUI

struct HeroTitle: View {
    private static let subtitleOpacity = 0.85
    private static let titleLines = 2
    private static let minimumScale = 0.7

    let title: String
    let subtitle: String

    var body: some View {
        return VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(verbatim: title)
                .appStyle(.largeTitle, weight: .bold)
                .foregroundStyle(Palette.white)
                .lineLimit(Self.titleLines)
                .minimumScaleFactor(Self.minimumScale)
            if !subtitle.isBlank {
                Text(verbatim: subtitle)
                    .appStyle(.headline)
                    .foregroundStyle(Palette.white.opacity(Self.subtitleOpacity))
                    .lineLimit(Self.titleLines)
                    .minimumScaleFactor(Self.minimumScale)
            }
        }
        .padding(Spacing.xxl)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
