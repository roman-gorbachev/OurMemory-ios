import SwiftUI

struct MemoryBanner: View {
    private static let flameContainerSize: CGFloat = 52
    private static let flameBackgroundOpacity = 0.18
    private static let subtitleOpacity = 0.85
    private static let padding: CGFloat = 20

    var body: some View {
        return HStack(spacing: Spacing.xl) {
            Image(systemName: "flame.fill")
                .font(.title)
                .symbolEffect(.pulse)
                .foregroundStyle(Palette.white)
                .frame(width: Self.flameContainerSize, height: Self.flameContainerSize)
                .background(Circle().fill(Palette.white.opacity(Self.flameBackgroundOpacity)))
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text("never_forgotten_msg")
                    .appStyle(.headline)
                    .foregroundStyle(Palette.white)
                Text("thank_you_for_keeping_memory_msg")
                    .appStyle(.footnote)
                    .foregroundStyle(Palette.white.opacity(Self.subtitleOpacity))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(Self.padding)
        .background(LinearGradient(colors: [Palette.brandRed, Palette.brandBrightRed], startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}

#Preview {
    MemoryBanner()
}
