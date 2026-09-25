import SwiftUI

struct DetailsScreen: View {
    private static let coordinateSpace = "details"
    private static let sectionSpacing: CGFloat = 28
    private static let heroAspectRatio: CGFloat = 0.9

    let data: DetailsUiData
    let playbackState: AudioPlaybackState
    let candleState: CandleState
    let isFavorite: Bool
    let onAction: (DetailsUserAction) -> Void
    let onShowOnMap: (String) -> Void
    let onAddToHistory: () -> Void
    let onReportError: () -> Void
    @State private var heroBottom: CGFloat = .greatestFiniteMagnitude

    var body: some View {
        return GeometryReader { proxy in
            let isCollapsed = heroBottom <= proxy.safeAreaInsets.top
            ScrollView {
                VStack(spacing: Self.sectionSpacing) {
                    StretchyHeader(height: proxy.size.width / Self.heroAspectRatio + proxy.safeAreaInsets.top) {
                        PortraitImage(url: data.portrait)
                    } overlay: {
                        HeroTitle(title: data.name, subtitle: data.years)
                    }
                    .background(alignment: .bottom) {
                        ScrollOffsetReader(coordinateSpace: Self.coordinateSpace) { heroBottom = $0 }
                    }
                    CandleCard(candleState: candleState) { onAction(.lightCandle) }
                    if !data.rewards.isEmpty {
                        RewardsRow(rewards: data.rewards)
                    }
                    if data.audio != nil {
                        AudioPlayerCard(playbackState: playbackState) { onAction(.audio($0)) }
                    }
                    if !data.paragraphs.isEmpty {
                        ExpandableTextSection(title: "biography", paragraphs: data.paragraphs)
                    }
                    if !data.media.isEmpty {
                        MediaGallery(title: "docs", media: data.media)
                    }
                    if let burial = data.burial {
                        BurialSection(burial: burial) { onShowOnMap(burial.id) }
                    }
                    ContributeSection(onAddToHistory: onAddToHistory, onReportError: onReportError)
                }
                .padding(.bottom, Spacing.xxxl)
            }
            .coordinateSpace(name: Self.coordinateSpace)
            .ignoresSafeArea(edges: .top)
            .navigationTitle(isCollapsed ? data.name : "")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(isCollapsed ? .visible : .hidden, for: .navigationBar)
            .toolbarColorScheme(isCollapsed ? nil : .dark, for: .navigationBar)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if let url = VeteranLink.url(forVeteranId: data.veteranId) {
                        ShareLink(item: url, subject: Text(verbatim: data.name))
                    }
                    Button {
                        onAction(.toggleFavorite)
                    } label: {
                        Label(isFavorite ? "remove_from_favorites" : "add_to_favorites", systemImage: isFavorite ? "heart.fill" : "heart")
                    }
                    .symbolEffect(.bounce, value: isFavorite)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isCollapsed)
        }
    }
}

#Preview {
    NavigationStack {
        DetailsScreen(
            data: DetailsUiData(
                veteranId: "10",
                name: "Иванов Иван Иванович",
                years: "1905–1966",
                portrait: "",
                rewards: [RewardCount(reward: .redStar, count: 2)],
                paragraphs: ["Биография"],
                media: [],
                audio: nil,
                burial: nil
            ),
            playbackState: AudioPlaybackState(),
            candleState: CandleState(count: 3, isLitToday: false),
            isFavorite: false,
            onAction: { _ in },
            onShowOnMap: { _ in },
            onAddToHistory: {},
            onReportError: {}
        )
    }
}
