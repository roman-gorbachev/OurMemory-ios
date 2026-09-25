import SwiftUI

struct ModerationListRoute: View {
    @State private var viewModel: ModerationListViewModel
    let onSubmissionOpen: (String) -> Void

    init(viewModel: ModerationListViewModel, onSubmissionOpen: @escaping (String) -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onSubmissionOpen = onSubmissionOpen
    }

    var body: some View {
        return content
            .navigationTitle("moderation")
            .task { await viewModel.loadNames() }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.moderationListUiState {
        case .loading:
            LoadingView()
        case .error:
            ErrorView()
        case .success(let items):
            List(items) { item in
                Button {
                    onSubmissionOpen(item.id)
                } label: {
                    SubmissionCard(item: item)
                }
                .buttonStyle(.plain)
            }
            .listStyle(.insetGrouped)
            .overlay {
                if items.isEmpty {
                    ContentUnavailableView("nothing_here_yet", systemImage: "tray")
                }
            }
        }
    }
}
