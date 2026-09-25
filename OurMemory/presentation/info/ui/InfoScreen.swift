import SwiftUI

struct InfoScreen: View {
    private static let coordinateSpace = "info"
    private static let sectionSpacing: CGFloat = 28
    private static let heroAspectRatio: CGFloat = 1.1

    let language: AppLanguage
    let onLanguageChange: (AppLanguage) -> Void
    let onOpenMap: () -> Void
    @State private var heroBottom: CGFloat = .greatestFiniteMagnitude
    @Environment(\.openURL) private var openURL

    var body: some View {
        return GeometryReader { proxy in
            let isCollapsed = heroBottom <= proxy.safeAreaInsets.top
            ScrollView {
                VStack(spacing: Self.sectionSpacing) {
                    StretchyHeader(height: proxy.size.width / Self.heroAspectRatio + proxy.safeAreaInsets.top) {
                        Image("warwar")
                            .resizable()
                            .scaledToFill()
                    } overlay: {
                        HeroTitle(title: L10n.string("warHeader"), subtitle: L10n.string("address"))
                    }
                    .background(alignment: .bottom) {
                        ScrollOffsetReader(coordinateSpace: Self.coordinateSpace) { heroBottom = $0 }
                    }
                    ExpandableTextSection(title: "historyInfoHeader", paragraphs: InfoContent.historyParagraphs())
                    MediaGallery(title: "galleryHeader", media: CemeteryPhotos.all.map { return MediaUi.asset($0) })
                    LocationSection(onOpenMap: onOpenMap) {
                        if let url = InfoContent.routeToCemetery {
                            openURL(url)
                        }
                    }
                    ContactsSection()
                    NewsSection(news: InfoContent.news) { openURL($0.url) }
                }
                .padding(.bottom, Spacing.xxxl)
            }
            .coordinateSpace(name: Self.coordinateSpace)
            .ignoresSafeArea(edges: .top)
            .background(Palette.groupedBackground)
            .navigationTitle(isCollapsed ? L10n.string("warHeader") : "")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(isCollapsed ? .visible : .hidden, for: .navigationBar)
            .toolbarColorScheme(isCollapsed ? nil : .dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("language", selection: Binding(get: { return language }, set: onLanguageChange)) {
                            ForEach(AppLanguage.allCases, id: \.self) { item in
                                Text(item.titleKey).tag(item)
                            }
                        }
                    } label: {
                        Label("language", systemImage: "globe")
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        InfoScreen(language: .russian, onLanguageChange: { _ in }, onOpenMap: {})
    }
}
