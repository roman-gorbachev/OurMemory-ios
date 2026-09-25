import SwiftUI

struct CandleCard: View {
    private static let iconSize: CGFloat = 52

    let candleState: CandleState
    let onLight: () -> Void

    var body: some View {
        let isLit = candleState.isLitToday
        return Button(action: onLight) {
            HStack(spacing: Spacing.xl) {
                Image(systemName: "flame.fill")
                    .font(.title2)
                    .foregroundStyle(isLit ? Palette.onSecondary : Palette.primary)
                    .frame(width: Self.iconSize, height: Self.iconSize)
                    .background(Circle().fill(isLit ? Palette.secondary : Palette.primaryContainer))
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(isLit ? "candle_is_lit" : "light_a_candle")
                        .appStyle(.titleMedium, weight: .bold)
                        .foregroundStyle(Palette.onSurface)
                    Text(verbatim: L10n.format("candles_count", candleState.count))
                        .appStyle(.bodyMedium)
                        .foregroundStyle(Palette.onSurfaceVariant)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(Spacing.xl)
            .background(RoundedRectangle(cornerRadius: CornerRadius.card).fill(Palette.container))
        }
        .buttonStyle(.plain)
        .disabled(isLit)
        .padding(.horizontal, Spacing.screen)
    }
}

#Preview {
    CandleCard(candleState: CandleState(count: 5, isLitToday: false)) {}
}
