import SwiftUI

struct CapsuleButton: View {
    private static let height: CGFloat = 40

    let title: String
    let action: () -> Void

    var body: some View {
        return Button(action: action) {
            Text(verbatim: title)
                .appStyle(.labelLarge, weight: .bold)
                .foregroundStyle(Palette.onSurface)
                .padding(.horizontal, Spacing.xl)
                .frame(height: Self.height)
                .background(Capsule().fill(Palette.glass))
                .shadow(color: Palette.shadow, radius: Shadow.smallRadius, y: Shadow.offsetY)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CapsuleButton(title: "БЕЛ") {}
}
