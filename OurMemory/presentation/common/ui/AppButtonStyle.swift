import SwiftUI

struct AppButtonStyle: ButtonStyle {
    private static let height: CGFloat = 50
    private static let pressedOpacity = 0.8
    private static let disabledOpacity = 0.4

    var kind = AppButtonKind.filled
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .appStyle(.labelLarge, weight: .bold)
            .foregroundStyle(kind == .filled ? Palette.onPrimary : Palette.primary)
            .padding(.horizontal, Spacing.xxl)
            .frame(maxWidth: .infinity, minHeight: Self.height)
            .background(background)
            .opacity(configuration.isPressed ? Self.pressedOpacity : 1)
            .opacity(isEnabled ? 1 : Self.disabledOpacity)
    }

    @ViewBuilder
    private var background: some View {
        switch kind {
        case .filled:
            Capsule().fill(Palette.primary)
        case .tonal:
            Capsule().fill(Palette.primaryContainer)
        case .outlined:
            Capsule().stroke(Palette.outline)
        case .text:
            Color.clear
        }
    }
}
