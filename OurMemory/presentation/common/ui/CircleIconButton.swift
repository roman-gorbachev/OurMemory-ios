import SwiftUI

struct CircleIconButton: View {
    private static let size: CGFloat = 40
    private static let iconSize: CGFloat = 17

    let systemImage: String
    let accessibilityLabel: LocalizedStringKey
    var background = Palette.dimmed
    var foreground = Palette.white
    let action: () -> Void

    var body: some View {
        return Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: Self.iconSize, weight: .semibold))
                .foregroundStyle(foreground)
                .frame(width: Self.size, height: Self.size)
                .background(Circle().fill(background))
                .shadow(color: Palette.shadow, radius: Shadow.smallRadius, y: Shadow.offsetY)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
    }
}

#Preview {
    CircleIconButton(systemImage: "chevron.left", accessibilityLabel: "back") {}
}
