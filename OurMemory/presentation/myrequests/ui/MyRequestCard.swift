import SwiftUI

struct MyRequestCard: View {
    private static let textLines = 4
    private static let statusBackgroundOpacity = 0.15

    let item: MyRequestItemUi

    var body: some View {
        return VStack(alignment: .leading, spacing: Spacing.s) {
            HStack {
                Label(item.kind.titleKey, systemImage: item.kind == .submission ? "photo.on.rectangle" : "envelope")
                    .appStyle(.caption)
                    .foregroundStyle(Palette.onSurfaceVariant)
                Spacer()
                Text(verbatim: item.date)
                    .appStyle(.caption)
                    .foregroundStyle(Palette.onSurfaceVariant)
            }
            if !item.veteranName.isBlank {
                Text(verbatim: item.veteranName)
                    .appStyle(.headline)
            }
            Text(verbatim: item.text)
                .appStyle(.callout)
                .lineLimit(Self.textLines)
            Text(item.status.titleKey)
                .appStyle(.caption, weight: .semibold)
                .foregroundStyle(statusColor)
                .padding(.horizontal, Spacing.m)
                .padding(.vertical, Spacing.xs)
                .background(Capsule().fill(statusColor.opacity(Self.statusBackgroundOpacity)))
            if !item.reply.isBlank {
                Text(verbatim: L10n.format("reply_from_cemetery", item.reply))
                    .appStyle(.callout)
                    .padding(Spacing.l)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: CornerRadius.medium, style: .continuous).fill(Palette.containerHigh))
            }
        }
        .padding(.vertical, Spacing.xs)
    }

    private var statusColor: Color {
        switch item.status {
        case .inReview:
            return .orange
        case .approved, .reviewed:
            return Palette.success
        case .rejected:
            return Palette.error
        }
    }
}
