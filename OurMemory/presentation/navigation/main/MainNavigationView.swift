import SwiftUI

struct MainNavigationView: View {
    let container: AppDIContainer
    let isAdmin: Bool
    let language: AppLanguage
    let onLanguageChange: (AppLanguage) -> Void
    @State private var router = MainRouter()
    private let deepLinks = DeepLinkCenter.shared

    var body: some View {
        return NavigationStack(path: $router.path) {
            TabContainerView(
                container: container,
                router: router,
                isAdmin: isAdmin,
                language: language,
                onLanguageChange: onLanguageChange
            )
            .modifier(VeteranNavigationDestinations(container: container, router: router))
            .modifier(MapNavigationDestinations(container: container, router: router))
            .modifier(MoreNavigationDestinations(container: container, router: router))
            .modifier(AdminNavigationDestinations(container: container, router: router))
        }
        .onChange(of: deepLinks.pendingVeteranId, initial: true) { _, veteranId in
            guard let veteranId else {
                return
            }
            deepLinks.pendingVeteranId = nil
            router.push(VeteranDestination.details(veteranId: veteranId))
        }
        .onChange(of: isAdmin) { _, isAdmin in
            if !isAdmin && router.selectedTab == .admin {
                router.switchTab(.more)
            }
        }
    }
}
