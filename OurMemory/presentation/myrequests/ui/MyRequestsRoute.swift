import SwiftUI

struct MyRequestsRoute: View {
    @State private var viewModel: MyRequestsViewModel
    @Environment(\.scenePhase) private var scenePhase
    let onBack: () -> Void

    init(viewModel: MyRequestsViewModel, onBack: @escaping () -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onBack = onBack
    }

    var body: some View {
        return TopBarContainer(title: L10n.string("my_requests"), onBack: onBack) {
            switch viewModel.myRequestsUiState {
            case .loading:
                LoadingView()
            case .error:
                ErrorView()
            case .success(let items):
                MyRequestsScreen(items: items)
            }
        }
        .task { await viewModel.loadNames() }
        .onAppear { viewModel.markAllSeen() }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                viewModel.markAllSeen()
            }
        }
    }
}
