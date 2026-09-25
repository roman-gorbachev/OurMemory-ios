import SwiftUI

struct SubmissionCard: View {
    private static let previewLines = 3

    let item: SubmissionItemUi

    var body: some View {
        let isPending = item.status == .pending
        return HStack(alignment: .top, spacing: Spacing.l) {
            Circle()
                .fill(isPending ? Palette.primary : Color.clear)
                .frame(width: Spacing.m, height: Spacing.m)
                .padding(.top, Spacing.s)
            VStack(alignment: .leading, spacing: Spacing.xs) {
                HStack {
                    Text(verbatim: item.veteranName)
                        .appStyle(.headline)
                        .lineLimit(1)
                    Spacer()
                    Text(verbatim: item.date)
                        .appStyle(.caption)
                        .foregroundStyle(Palette.onSurfaceVariant)
                }
                Text(verbatim: item.text)
                    .appStyle(.subheadline)
                    .foregroundStyle(Palette.onSurfaceVariant)
                    .lineLimit(Self.previewLines)
                HStack {
                    Text(item.status.titleKey)
                        .appStyle(.caption, weight: .semibold)
                        .foregroundStyle(isPending ? Palette.primary : Palette.onSurfaceVariant)
                    Spacer()
                    if item.photoCount > 0 {
                        Label { Text(verbatim: L10n.format("photos_count", item.photoCount)) } icon: { Image(systemName: "photo") }
                            .appStyle(.caption)
                            .foregroundStyle(Palette.onSurfaceVariant)
                    }
                }
            }
        }
        .contentShape(Rectangle())
    }
}
