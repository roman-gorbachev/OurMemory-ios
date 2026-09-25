import SwiftUI

struct NewsSection: View {
    private static let iconSize: CGFloat = 40

    let news: [NewsUi]
    let onOpen: (NewsUi) -> Void

    var body: some View {
        return VStack(alignment: .leading, spacing: 0) {
            SectionTitle(text: "news")
            VStack(spacing: Spacing.m) {
                ForEach(news) { item in
                    Button {
                        onOpen(item)
                    } label: {
                        HStack(spacing: Spacing.l) {
                            Image(item.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: Self.iconSize, height: Self.iconSize)
                                .clipShape(Circle())
                            Text(verbatim: item.title)
                                .appStyle(.titleMedium, weight: .bold)
                                .foregroundStyle(Palette.onSurface)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Palette.primary)
                        }
                        .padding(Spacing.l)
                        .background(RoundedRectangle(cornerRadius: CornerRadius.extraLarge).fill(Palette.container))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, Spacing.screen)
        }
    }
}
