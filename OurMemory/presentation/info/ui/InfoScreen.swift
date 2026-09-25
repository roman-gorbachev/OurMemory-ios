import SwiftUI

struct InfoScreen: View {
    private static let coordinateSpace = "info"
    private static let sectionSpacing: CGFloat = 28
    private static let heroAspectRatio: CGFloat = 1.1
    private static let addressOpacity = 0.85
    private static let heroTextPadding: CGFloat = 20

    let language: AppLanguage
    let onLanguageChange: (AppLanguage) -> Void
    let onOpenMap: () -> Void
    @State private var heroBottom: CGFloat = .greatestFiniteMagnitude
    @Environment(\.openURL) private var openURL

    var body: some View {
        return GeometryReader { proxy in
            let isCollapsed = heroBottom <= proxy.safeAreaInsets.top + Spacing.topBarHeight
            ScrollView {
                VStack(spacing: Self.sectionSpacing) {
                    hero(height: proxy.size.width / Self.heroAspectRatio + proxy.safeAreaInsets.top)
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
                .padding(.bottom, Spacing.xxxl + Spacing.tabBarInset)
            }
            .coordinateSpace(name: Self.coordinateSpace)
            .ignoresSafeArea(edges: .top)
            .overlay(alignment: .top) {
                FloatingTopBar(title: L10n.string("warHeader"), isCollapsed: isCollapsed, onBack: nil) {
                    CapsuleButton(title: L10n.string(language == .russian ? "bel" : "rus")) {
                        onLanguageChange(language == .russian ? .belarusian : .russian)
                    }
                }
            }
        }
        .background(Palette.background.ignoresSafeArea())
    }

    private func hero(height: CGFloat) -> some View {
        return ZStack(alignment: .bottomLeading) {
            Color.clear
                .overlay {
                    Image("warwar")
                        .resizable()
                        .scaledToFill()
                }
                .clipped()
            HeroScrim()
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("warHeader")
                    .appStyle(.headlineMedium, weight: .bold)
                    .foregroundStyle(Palette.white)
                Text("address")
                    .appStyle(.titleMedium)
                    .foregroundStyle(Palette.white.opacity(Self.addressOpacity))
            }
            .padding(Self.heroTextPadding)
        }
        .frame(height: height)
        .frame(maxWidth: .infinity)
        .clipped()
    }
}

#Preview {
    InfoScreen(language: .russian, onLanguageChange: { _ in }, onOpenMap: {})
}
