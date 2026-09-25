import SwiftUI

@Observable
final class MainRouter: Router {
    var selectedTab = TopLevelTab.veterans
    var paths: [TopLevelTab: NavigationPath] = [:]

    var path: NavigationPath {
        get {
            return paths[selectedTab] ?? NavigationPath()
        }
        set {
            paths[selectedTab] = newValue
        }
    }

    func binding(for tab: TopLevelTab) -> Binding<NavigationPath> {
        return Binding(
            get: { return self.paths[tab] ?? NavigationPath() },
            set: { self.paths[tab] = $0 }
        )
    }

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

    func openVeteran(_ veteranId: String) {
        push(VeteranDestination.details(veteranId: veteranId))
    }
}
