import SwiftUI

struct VeteranRow: View {
    private static let portraitWidthRatio: CGFloat = 1.0 / 3.0
    private static let portraitAspectRatio: CGFloat = 0.8
    private static let baseInfoLines = 5
    private static let rowPadding: CGFloat = 10

    let veteran: VeteranItemUi
    let action: () -> Void

    var body: some View {
        return Button(action: action) {
            HStack(alignment: .top, spacing: Spacing.l) {
                Color.clear
                    .aspectRatio(Self.portraitAspectRatio, contentMode: .fit)
                    .overlay { PortraitImage(url: veteran.portrait) }
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
                    .containerRelativeFrame(.horizontal) { width, _ in
                        return (width - Spacing.screen * 2 - Self.rowPadding * 2 - Spacing.l) * Self.portraitWidthRatio
                    }
                VStack(alignment: .leading, spacing: 0) {
                    Text(verbatim: veteran.name)
                        .appStyle(.titleSmall, weight: .bold)
                        .foregroundStyle(Palette.primary)
                    if !veteran.years.isBlank {
                        Text(verbatim: veteran.years)
                            .appStyle(.bodySmall)
                            .foregroundStyle(Palette.onSurfaceVariant)
                            .padding(.top, Spacing.xxs)
                    }
                    Text(verbatim: veteran.baseInfo)
                        .appStyle(.bodySmall)
                        .foregroundStyle(Palette.onSurface)
                        .lineLimit(Self.baseInfoLines)
                        .padding(.top, Spacing.s)
                }
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(Self.rowPadding)
            .background(RoundedRectangle(cornerRadius: CornerRadius.extraLarge).fill(Palette.container))
            .contentShape(RoundedRectangle(cornerRadius: CornerRadius.extraLarge))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, Spacing.screen)
        .padding(.vertical, Spacing.s)
    }
}

#Preview {
    VeteranRow(
        veteran: VeteranItemUi(id: "1", name: "Иванов Иван", years: "1905–1966", baseInfo: "Описание", portrait: ""),
        action: {}
    )
}
