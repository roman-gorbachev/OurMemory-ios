import SwiftUI

struct MapNavigationDestinations: ViewModifier {
    let container: AppDIContainer
    let router: MainRouter

    func body(content: Content) -> some View {
        return content.navigationDestination(for: MapDestination.self) { destination in
            switch destination {
            case .burialMap(let burialId):
                MapRoute(
                    viewModel: container.buildMapViewModel(focusedBurialId: burialId),
                    isRoot: false,
                    onVeteranOpen: router.openVeteran,
                    onTourOpen: { router.push(MapDestination.tour(tourId: $0)) }
                )
            case .tour(let tourId):
                TourRoute(viewModel: container.buildTourViewModel(tourId: tourId))
            }
        }
    }
}
