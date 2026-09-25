import SwiftUI

@Observable
final class MainRouter: Router {
    var path = NavigationPath()
    var selectedTab = TopLevelTab.veterans

    func push<Destination: Hashable>(_ destination: Destination) {
        path.append(destination)
    }

    func pop() {
        guard !path.isEmpty else {
            return
        }
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }

    func switchTab(_ tab: TopLevelTab) {
        popToRoot()
        selectedTab = tab
    }
}
