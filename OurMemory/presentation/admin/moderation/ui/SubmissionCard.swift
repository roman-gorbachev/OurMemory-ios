import SwiftUI

struct SubmissionCard: View {
    private static let previewLines = 3

    let item: SubmissionItemUi
    let action: () -> Void

    var body: some View {
        let isPending = item.status == .pending
        return Button(action: action) {
            VStack(alignment: .leading, spacing: Spacing.s) {
                HStack {
                    Text(verbatim: item.veteranName)
                        .appStyle(.titleMedium, weight: .bold)
                        .foregroundStyle(Palette.primary)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(verbatim: item.date)
                        .appStyle(.labelMedium)
                        .foregroundStyle(Palette.onSurfaceVariant)
                }
                Text(verbatim: item.text)
                    .appStyle(.bodyMedium)
                    .foregroundStyle(Palette.onSurface)
                    .lineLimit(Self.previewLines)
                HStack {
                    Text(item.status.titleKey)
                        .appStyle(.labelLarge)
                        .foregroundStyle(isPending ? Palette.primary : Palette.onSurfaceVariant)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if item.photoCount > 0 {
                        Text(verbatim: L10n.format("photos_count", item.photoCount))
                            .appStyle(.labelLarge)
                            .foregroundStyle(Palette.onSurfaceVariant)
                    }
                }
            }
            .multilineTextAlignment(.leading)
            .padding(Spacing.xl)
            .background(RoundedRectangle(cornerRadius: CornerRadius.large).fill(isPending ? Palette.surface : Palette.surfaceVariant))
            .shadow(color: isPending ? Palette.shadow : .clear, radius: Shadow.smallRadius, y: Shadow.offsetY)
        }
        .buttonStyle(.plain)
    }
}
