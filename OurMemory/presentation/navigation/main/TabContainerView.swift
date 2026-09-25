import SwiftUI

struct TabContainerView: View {
    let container: AppDIContainer
    let router: MainRouter
    let isAdmin: Bool
    let language: AppLanguage
    let onLanguageChange: (AppLanguage) -> Void
    @State private var visitedTabs: Set<TopLevelTab> = [.veterans]

    var body: some View {
        return ZStack(alignment: .bottom) {
            ForEach(tabs, id: \.self) { tab in
                if visitedTabs.contains(tab) {
                    tabRoot(tab)
                        .opacity(router.selectedTab == tab ? 1 : 0)
                        .allowsHitTesting(router.selectedTab == tab)
                        .accessibilityHidden(router.selectedTab != tab)
                }
            }
            AppTabBar(tabs: tabs, selectedTab: router.selectedTab) { tab in
                router.selectedTab = tab
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .background(Palette.background.ignoresSafeArea())
        .onChange(of: router.selectedTab, initial: true) { _, tab in
            visitedTabs.insert(tab)
        }
    }

    private var tabs: [TopLevelTab] {
        return TopLevelTab.allCases.filter { return $0 != .admin || isAdmin }
    }

    @ViewBuilder
    private func tabRoot(_ tab: TopLevelTab) -> some View {
        switch tab {
        case .veterans:
            HomeRoute(viewModel: container.buildHomeViewModel()) { veteranId in
                router.push(VeteranDestination.details(veteranId: veteranId))
            }
        case .map:
            MapRoute(
                viewModel: container.buildMapViewModel(focusedBurialId: nil),
                onBack: nil,
                onVeteranOpen: { router.push(VeteranDestination.details(veteranId: $0)) },
                onTourOpen: { router.push(MapDestination.tour(tourId: $0)) }
            )
        case .about:
            InfoScreen(language: language, onLanguageChange: onLanguageChange) {
                router.selectedTab = .map
            }
        case .more:
            MoreRoute(
                viewModel: container.buildMoreViewModel(),
                onWriteToUs: { router.push(VeteranDestination.feedback(veteranId: "")) },
                onMyRequests: { router.push(MoreDestination.myRequests) },
                onFavorites: { router.push(MoreDestination.favorites) },
                onVeteranOpen: { router.push(VeteranDestination.details(veteranId: $0)) },
                onAdmin: {
                    if isAdmin {
                        router.selectedTab = .admin
                    } else {
                        router.push(MoreDestination.adminLogin)
                    }
                }
            )
        case .admin:
            ErrorView()
        }
    }
}
