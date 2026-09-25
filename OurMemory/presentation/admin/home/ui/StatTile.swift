import SwiftUI

struct StatTile: View {
    let count: Int
    let title: LocalizedStringKey
    let systemImage: String
    let action: () -> Void

    var body: some View {
        let hasNew = count > 0
        return Button(action: action) {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                HStack {
                    Text(verbatim: String(count))
                        .appStyle(.displaySmall, weight: .bold)
                        .foregroundStyle(hasNew ? Palette.primary : Palette.onSurfaceVariant)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: systemImage)
                        .foregroundStyle(Palette.primary)
                }
                Text(title)
                    .appStyle(.titleSmall, weight: .semibold)
                    .foregroundStyle(Palette.onSurface)
                if !hasNew {
                    Text("everything_is_reviewed_msg")
                        .appStyle(.bodySmall)
                        .foregroundStyle(Palette.onSurfaceVariant)
                }
                Spacer(minLength: 0)
            }
            .multilineTextAlignment(.leading)
            .padding(Spacing.xl)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(RoundedRectangle(cornerRadius: CornerRadius.group).fill(hasNew ? Palette.primaryContainer : Palette.containerLow))
        }
        .buttonStyle(.plain)
    }
}
