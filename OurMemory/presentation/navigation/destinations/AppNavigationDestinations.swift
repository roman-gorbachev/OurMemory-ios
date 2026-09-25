import SwiftUI

struct AppNavigationDestinations: ViewModifier {
    let container: AppDIContainer
    let router: MainRouter

    func body(content: Content) -> some View {
        return content
            .modifier(VeteranNavigationDestinations(container: container, router: router))
            .modifier(MapNavigationDestinations(container: container, router: router))
            .modifier(MoreNavigationDestinations(container: container, router: router))
            .modifier(AdminNavigationDestinations(container: container, router: router))
    }
}
