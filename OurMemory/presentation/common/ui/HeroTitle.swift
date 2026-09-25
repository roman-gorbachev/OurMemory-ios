import SwiftUI

struct HeroTitle: View {
    private static let subtitleOpacity = 0.85

    let title: String
    let subtitle: String

    var body: some View {
        return VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(verbatim: title)
                .appStyle(.largeTitle, weight: .bold)
                .foregroundStyle(Palette.white)
            if !subtitle.isBlank {
                Text(verbatim: subtitle)
                    .appStyle(.headline)
                    .foregroundStyle(Palette.white.opacity(Self.subtitleOpacity))
            }
        }
        .padding(Spacing.xxl)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
