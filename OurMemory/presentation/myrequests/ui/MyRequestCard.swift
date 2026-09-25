import SwiftUI

struct MyRequestCard: View {
    private static let textLines = 4

    let item: MyRequestItemUi

    var body: some View {
        return VStack(alignment: .leading, spacing: Spacing.s) {
            HStack {
                Text(item.kind.titleKey)
                    .appStyle(.labelLarge)
                    .foregroundStyle(Palette.onSurfaceVariant)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(verbatim: item.date)
                    .appStyle(.labelMedium)
                    .foregroundStyle(Palette.onSurfaceVariant)
            }
            if !item.veteranName.isBlank {
                Text(verbatim: item.veteranName)
                    .appStyle(.titleMedium, weight: .bold)
                    .foregroundStyle(Palette.primary)
            }
            Text(verbatim: item.text)
                .appStyle(.bodyMedium)
                .foregroundStyle(Palette.onSurface)
                .lineLimit(Self.textLines)
            Text(item.status.titleKey)
                .appStyle(.labelLarge, weight: .bold)
                .foregroundStyle(item.status == .rejected ? Palette.error : Palette.primary)
            if !item.reply.isBlank {
                Text(verbatim: L10n.format("reply_from_cemetery", item.reply))
                    .appStyle(.bodyMedium)
                    .foregroundStyle(Palette.onSurface)
            }
        }
        .padding(Spacing.xl)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: CornerRadius.large).fill(Palette.surface))
        .shadow(color: Palette.shadow, radius: Shadow.smallRadius, y: Shadow.offsetY)
    }
}
