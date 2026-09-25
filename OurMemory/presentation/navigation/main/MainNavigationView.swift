import SwiftUI

struct MainNavigationView: View {
    let container: AppDIContainer
    let isAdmin: Bool
    let language: AppLanguage
    let onLanguageChange: (AppLanguage) -> Void
    @State private var router = MainRouter()
    private let deepLinks = DeepLinkCenter.shared

    var body: some View {
        return TabView(selection: $router.selectedTab) {
            ForEach(tabs, id: \.self) { tab in
                NavigationStack(path: router.binding(for: tab)) {
                    tabRoot(tab)
                        .modifier(AppNavigationDestinations(container: container, router: router))
                }
                .tabItem { Label(tab.titleKey, systemImage: tab.systemImage) }
                .tag(tab)
            }
        }
        .onChange(of: deepLinks.pendingVeteranId, initial: true) { _, veteranId in
            guard let veteranId else {
                return
            }
            deepLinks.pendingVeteranId = nil
            router.selectedTab = .veterans
            router.openVeteran(veteranId)
        }
        .onChange(of: isAdmin) { _, isAdmin in
            if !isAdmin && router.selectedTab == .admin {
                router.switchTab(.more)
            }
        }
    }

    private var tabs: [TopLevelTab] {
        return TopLevelTab.allCases.filter { return $0 != .admin || isAdmin }
    }

    @ViewBuilder
    private func tabRoot(_ tab: TopLevelTab) -> some View {
        switch tab {
        case .veterans:
            HomeRoute(viewModel: container.buildHomeViewModel(), onVeteranOpen: router.openVeteran)
        case .map:
            MapRoute(
                viewModel: container.buildMapViewModel(focusedBurialId: nil),
                isRoot: true,
                onVeteranOpen: router.openVeteran,
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
                onVeteranOpen: router.openVeteran,
                onAdmin: {
                    if isAdmin {
                        router.selectedTab = .admin
                    } else {
                        router.push(MoreDestination.adminLogin)
                    }
                }
            )
        case .admin:
            AdminHomeRoute(
                viewModel: container.buildAdminHomeViewModel(),
                onOpen: { router.push($0) },
                onSignedOut: { router.switchTab(.more) }
            )
        }
    }
}
