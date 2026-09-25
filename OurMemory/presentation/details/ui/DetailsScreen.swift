import SwiftUI

struct DetailsScreen: View {
    private static let coordinateSpace = "details"
    private static let sectionSpacing: CGFloat = 28
    private static let heroAspectRatio: CGFloat = 0.85

    let data: DetailsUiData
    let playbackState: AudioPlaybackState
    let candleState: CandleState
    let isFavorite: Bool
    let onAction: (DetailsUserAction) -> Void
    let onBack: () -> Void
    let onShowOnMap: (String) -> Void
    let onAddToHistory: () -> Void
    let onReportError: () -> Void
    @State private var heroBottom: CGFloat = .greatestFiniteMagnitude

    var body: some View {
        return GeometryReader { proxy in
            let heroHeight = proxy.size.width / Self.heroAspectRatio
            let isCollapsed = heroBottom <= proxy.safeAreaInsets.top + Spacing.topBarHeight
            ScrollView {
                VStack(spacing: Self.sectionSpacing) {
                    DetailsHeader(name: data.name, years: data.years, portrait: data.portrait, height: heroHeight + proxy.safeAreaInsets.top)
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
            .overlay(alignment: .top) {
                FloatingTopBar(title: data.name, isCollapsed: isCollapsed, onBack: onBack) {
                    CircleIconButton(
                        systemImage: isFavorite ? "heart.fill" : "heart",
                        accessibilityLabel: isFavorite ? "remove_from_favorites" : "add_to_favorites",
                        foreground: Palette.primary
                    ) {
                        onAction(.toggleFavorite)
                    }
                }
            }
        }
    }
}

#Preview {
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
        onBack: {},
        onShowOnMap: { _ in },
        onAddToHistory: {},
        onReportError: {}
    )
}
