import SwiftUI

struct PhotoViewer: View {
    let media: [MediaUi]
    let onDismiss: () -> Void
    @State private var page: Int

    init(media: [MediaUi], initialPage: Int, onDismiss: @escaping () -> Void) {
        self.media = media
        self.onDismiss = onDismiss
        _page = State(initialValue: initialPage)
    }

    var body: some View {
        let description = media.indices.contains(page) ? media[page].description : ""
        return ZStack {
            Palette.black.ignoresSafeArea()
            TabView(selection: $page) {
                ForEach(Array(media.enumerated()), id: \.offset) { index, item in
                    ZoomableImage(url: item.url)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            VStack {
                CircleIconButton(
                    systemImage: "chevron.left",
                    accessibilityLabel: "back",
                    background: Palette.dimmed,
                    foreground: Palette.white,
                    action: onDismiss
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(Spacing.l)
                Spacer()
                if !description.isBlank {
                    Text(verbatim: description)
                        .appStyle(.body)
                        .foregroundStyle(Palette.white)
                        .padding(Spacing.xl)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Palette.captionBackground.ignoresSafeArea(edges: .bottom))
                }
            }
        }
    }
}

#Preview {
    PhotoViewer(media: [MediaUi(url: "", description: "Подпись")], initialPage: 0) {}
}
