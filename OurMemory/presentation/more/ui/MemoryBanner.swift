import SwiftUI

struct MemoryBanner: View {
    private static let flameContainerSize: CGFloat = 52
    private static let flameSize: CGFloat = 28
    private static let flameMinOpacity = 0.6
    private static let pulseSeconds = 1.4
    private static let flameBackgroundOpacity = 0.16
    private static let subtitleOpacity = 0.85
    private static let padding: CGFloat = 20

    @State private var isPulsing = false

    var body: some View {
        return HStack(spacing: Spacing.xl) {
            Image(systemName: "flame.fill")
                .font(.system(size: Self.flameSize))
                .foregroundStyle(Palette.white)
                .opacity(isPulsing ? 1 : Self.flameMinOpacity)
                .frame(width: Self.flameContainerSize, height: Self.flameContainerSize)
                .background(Circle().fill(Palette.white.opacity(Self.flameBackgroundOpacity)))
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text("never_forgotten_msg")
                    .appStyle(.titleMedium, weight: .bold)
                    .foregroundStyle(Palette.white)
                Text("thank_you_for_keeping_memory_msg")
                    .appStyle(.bodySmall)
                    .foregroundStyle(Palette.white.opacity(Self.subtitleOpacity))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(Self.padding)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.group)
                .fill(LinearGradient(colors: [Palette.brandRed, Palette.brandBrightRed], startPoint: .topLeading, endPoint: .bottomTrailing))
        )
        .onAppear {
            withAnimation(.easeInOut(duration: Self.pulseSeconds).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
        }
    }
}

#Preview {
    MemoryBanner()
        .padding()
}
