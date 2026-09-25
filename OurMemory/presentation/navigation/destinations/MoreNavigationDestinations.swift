import SwiftUI

struct MoreNavigationDestinations: ViewModifier {
    let container: AppDIContainer
    let router: MainRouter

    func body(content: Content) -> some View {
        return content.navigationDestination(for: MoreDestination.self) { destination in
            switch destination {
            case .myRequests:
                MyRequestsRoute(viewModel: container.buildMyRequestsViewModel(), onBack: router.pop)
            case .favorites:
                FavoritesRoute(
                    viewModel: container.buildFavoritesViewModel(),
                    onBack: router.pop,
                    onVeteranOpen: { router.push(VeteranDestination.details(veteranId: $0)) }
                )
            case .adminLogin:
                AdminLoginRoute(
                    viewModel: container.buildAdminLoginViewModel(),
                    onBack: router.pop,
                    onSignedIn: { router.switchTab(.admin) }
                )
            }
        }
    }
}
