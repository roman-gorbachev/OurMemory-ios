import SwiftUI

struct LinkRow: View {
    private static let verticalPadding: CGFloat = 18

    let title: LocalizedStringKey
    var count = 0
    let action: () -> Void

    var body: some View {
        return Button(action: action) {
            HStack(spacing: Spacing.m) {
                Text(title)
                    .appStyle(.titleMedium)
                    .foregroundStyle(Palette.onSurface)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if count > 0 {
                    CountBadge(count: count)
                }
                ChevronIcon()
            }
            .padding(.horizontal, Spacing.xl)
            .padding(.vertical, Self.verticalPadding)
            .background(RoundedRectangle(cornerRadius: CornerRadius.large).fill(Palette.surface))
            .shadow(color: Palette.shadow, radius: Shadow.smallRadius, y: Shadow.offsetY)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    LinkRow(title: "moderation", count: 2) {}
        .padding()
}
