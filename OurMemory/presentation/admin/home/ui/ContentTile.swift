import SwiftUI

struct ContentTile: View {
    private static let iconContainer: CGFloat = 44
    private static let subtitleLines = 2

    let title: LocalizedStringKey
    let subtitle: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        return Button(action: action) {
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Image(systemName: systemImage)
                    .foregroundStyle(Palette.primary)
                    .frame(width: Self.iconContainer, height: Self.iconContainer)
                    .background(Circle().fill(Palette.primaryContainer))
                    .padding(.bottom, Spacing.m)
                Text(title)
                    .appStyle(.titleMedium, weight: .bold)
                    .foregroundStyle(Palette.onSurface)
                Text(verbatim: subtitle)
                    .appStyle(.bodySmall)
                    .foregroundStyle(Palette.onSurfaceVariant)
                    .lineLimit(Self.subtitleLines, reservesSpace: true)
                Spacer(minLength: 0)
            }
            .multilineTextAlignment(.leading)
            .padding(Spacing.xl)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(RoundedRectangle(cornerRadius: CornerRadius.group).fill(Palette.containerLow))
        }
        .buttonStyle(.plain)
    }
}
