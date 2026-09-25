import SwiftUI

struct VeteranRow: View {
    private static let portraitWidth: CGFloat = 64
    private static let portraitHeight: CGFloat = 80
    private static let baseInfoLines = 3

    let veteran: VeteranItemUi

    var body: some View {
        return HStack(alignment: .top, spacing: Spacing.l) {
            PortraitImage(url: veteran.portrait)
                .frame(width: Self.portraitWidth, height: Self.portraitHeight)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(verbatim: veteran.name)
                    .appStyle(.headline)
                    .foregroundStyle(Palette.onSurface)
                if !veteran.years.isBlank {
                    Text(verbatim: veteran.years)
                        .appStyle(.subheadline)
                        .foregroundStyle(Palette.primary)
                }
                Text(verbatim: veteran.baseInfo)
                    .appStyle(.footnote)
                    .foregroundStyle(Palette.onSurfaceVariant)
                    .lineLimit(Self.baseInfoLines)
                    .padding(.top, Spacing.xxs)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, Spacing.xs)
        .contentShape(Rectangle())
    }
}

#Preview {
    List {
        VeteranRow(veteran: VeteranItemUi(id: "1", name: "Иванов Иван", years: "1905–1966", baseInfo: "Описание", portrait: ""))
    }
}
