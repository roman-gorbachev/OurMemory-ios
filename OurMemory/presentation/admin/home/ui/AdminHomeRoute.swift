import SwiftUI

struct AdminHomeRoute: View {
    @State private var viewModel: AdminHomeViewModel
    let onOpen: (AdminDestination) -> Void
    let onSignedOut: () -> Void

    init(viewModel: AdminHomeViewModel, onOpen: @escaping (AdminDestination) -> Void, onSignedOut: @escaping () -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onOpen = onOpen
        self.onSignedOut = onSignedOut
    }

    var body: some View {
        return AdminHomeScreen(
            data: viewModel.adminHomeUiData,
            onOpen: onOpen,
            onSignOut: {
                viewModel.signOut()
                onSignedOut()
            }
        )
        .task { await viewModel.loadContentCounts() }
    }
}
