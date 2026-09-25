import SwiftUI

extension View {
    func cardBackground() -> some View {
        return padding(Spacing.xl)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: CornerRadius.card, style: .continuous).fill(Palette.surface))
            .padding(.horizontal, Spacing.screen)
    }
}
