import SwiftUI

struct NewsSection: View {
    private static let iconSize: CGFloat = 36

    let news: [NewsUi]
    let onOpen: (NewsUi) -> Void

    var body: some View {
        return VStack(alignment: .leading, spacing: 0) {
            SectionTitle(text: "news")
            VStack(spacing: 0) {
                ForEach(Array(news.enumerated()), id: \.element.id) { index, item in
                    if index > 0 {
                        Divider().padding(.leading, Self.iconSize + Spacing.xl + Spacing.l)
                    }
                    Button {
                        onOpen(item)
                    } label: {
                        HStack(spacing: Spacing.l) {
                            Image(item.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: Self.iconSize, height: Self.iconSize)
                                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small, style: .continuous))
                            Text(verbatim: item.title)
                                .appStyle(.body)
                                .foregroundStyle(Palette.onSurface)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Image(systemName: "arrow.up.right")
                                .appStyle(.footnote, weight: .semibold)
                                .foregroundStyle(Palette.tertiaryLabel)
                        }
                        .padding(.horizontal, Spacing.xl)
                        .padding(.vertical, Spacing.l)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .background(RoundedRectangle(cornerRadius: CornerRadius.card, style: .continuous).fill(Palette.surface))
            .padding(.horizontal, Spacing.screen)
        }
    }
}
