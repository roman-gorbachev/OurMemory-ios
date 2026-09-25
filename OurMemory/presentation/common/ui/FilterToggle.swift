import SwiftUI

struct FilterToggle: View {
    private static let height: CGFloat = 32
    private static let borderWidth: CGFloat = 1

    let title: LocalizedStringKey
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        return Button(action: action) {
            HStack(spacing: Spacing.s) {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.caption.weight(.bold))
                }
                Text(title)
                    .appStyle(.labelLarge)
            }
            .foregroundStyle(isSelected ? Palette.onPrimaryContainer : Palette.onSurfaceVariant)
            .padding(.horizontal, Spacing.l)
            .frame(height: Self.height)
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.small)
                    .fill(isSelected ? Palette.primaryContainer : Palette.surface)
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.small)
                    .stroke(isSelected ? Color.clear : Palette.outlineVariant, lineWidth: Self.borderWidth)
            )
            .shadow(color: Palette.shadow, radius: Shadow.smallRadius, y: Shadow.offsetY)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    FilterToggle(title: "art", isSelected: true) {}
}
