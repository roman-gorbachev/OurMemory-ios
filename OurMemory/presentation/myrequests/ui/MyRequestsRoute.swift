import SwiftUI

struct MyRequestsRoute: View {
    @State private var viewModel: MyRequestsViewModel
    @Environment(\.scenePhase) private var scenePhase

    init(viewModel: MyRequestsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        return content
            .navigationTitle("my_requests")
            .task { await viewModel.loadNames() }
            .onAppear { viewModel.markAllSeen() }
            .onChange(of: scenePhase) { _, phase in
                if phase == .active {
                    viewModel.markAllSeen()
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.myRequestsUiState {
        case .loading:
            LoadingView()
        case .error:
            ErrorView()
        case .success(let items):
            List(items) { item in
                MyRequestCard(item: item)
            }
            .listStyle(.insetGrouped)
            .overlay {
                if items.isEmpty {
                    ContentUnavailableView("my_requests", systemImage: "tray", description: Text("no_requests_yet_msg"))
                }
            }
        }
    }
}
