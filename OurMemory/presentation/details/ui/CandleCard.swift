import SwiftUI

struct CandleCard: View {
    private static let iconSize: CGFloat = 48

    let candleState: CandleState
    let onLight: () -> Void

    var body: some View {
        let isLit = candleState.isLitToday
        return HStack(spacing: Spacing.xl) {
            Image(systemName: "flame.fill")
                .font(.title2)
                .symbolEffect(.pulse, isActive: isLit)
                .foregroundStyle(isLit ? Palette.white : Palette.primary)
                .frame(width: Self.iconSize, height: Self.iconSize)
                .background(Circle().fill(isLit ? Palette.primary : Palette.primaryContainer))
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(isLit ? "candle_is_lit" : "light_a_candle")
                    .appStyle(.headline)
                    .foregroundStyle(Palette.onSurface)
                Text(verbatim: L10n.format("candles_count", candleState.count))
                    .appStyle(.subheadline)
                    .foregroundStyle(Palette.onSurfaceVariant)
                    .contentTransition(.numericText())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            if !isLit {
                Button(action: onLight) {
                    Image(systemName: "hand.tap")
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.circle)
                .accessibilityLabel("light_a_candle")
            }
        }
        .cardBackground()
        .sensoryFeedback(.success, trigger: isLit)
        .animation(.snappy, value: candleState)
    }
}

#Preview {
    CandleCard(candleState: CandleState(count: 5, isLitToday: false)) {}
        .background(Palette.groupedBackground)
}
