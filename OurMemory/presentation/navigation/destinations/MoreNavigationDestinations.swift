import SwiftUI

struct MoreNavigationDestinations: ViewModifier {
    let container: AppDIContainer
    let router: MainRouter

    func body(content: Content) -> some View {
        return content.navigationDestination(for: MoreDestination.self) { destination in
            switch destination {
            case .myRequests:
                MyRequestsRoute(viewModel: container.buildMyRequestsViewModel())
            case .favorites:
                FavoritesRoute(viewModel: container.buildFavoritesViewModel(), onVeteranOpen: router.openVeteran)
            case .adminLogin:
                AdminLoginRoute(viewModel: container.buildAdminLoginViewModel()) { router.switchTab(.admin) }
            }
        }
    }
}
