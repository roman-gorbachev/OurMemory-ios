import SwiftUI

struct MediaGallery: View {
    private static let thumbnailWidth: CGFloat = 160
    private static let thumbnailAspectRatio: CGFloat = 0.8
    private static let captionLines = 2

    let title: LocalizedStringKey
    let media: [MediaUi]
    @State private var openedPage: OpenedPage?

    var body: some View {
        return VStack(alignment: .leading, spacing: 0) {
            SectionTitle(text: title)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: Spacing.l) {
                    ForEach(Array(media.enumerated()), id: \.offset) { index, item in
                        Button {
                            openedPage = OpenedPage(index: index)
                        } label: {
                            thumbnail(item)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, Spacing.screen)
            }
        }
        .fullScreenCover(item: $openedPage) { page in
            PhotoViewer(media: media, initialPage: page.index) {
                openedPage = nil
            }
        }
    }

    private func thumbnail(_ item: MediaUi) -> some View {
        return VStack(alignment: .leading, spacing: Spacing.s) {
            Color.clear
                .frame(width: Self.thumbnailWidth, height: Self.thumbnailWidth / Self.thumbnailAspectRatio)
                .overlay { RemoteImage(url: item.url) }
                .background(Palette.containerHigh)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.large))
            if !item.description.isBlank {
                Text(verbatim: item.description)
                    .appStyle(.bodySmall)
                    .foregroundStyle(Palette.onSurfaceVariant)
                    .lineLimit(Self.captionLines)
                    .frame(width: Self.thumbnailWidth, alignment: .leading)
            }
        }
    }
}

private struct OpenedPage: Identifiable {
    let index: Int

    var id: Int {
        return index
    }
}

#Preview {
    MediaGallery(title: "docs", media: [MediaUi(url: "", description: "Фото")])
}
