import SwiftUI

struct FeedbackListRoute: View {
    @State private var viewModel: FeedbackListViewModel
    let onVeteranOpen: (String) -> Void

    init(viewModel: FeedbackListViewModel, onVeteranOpen: @escaping (String) -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onVeteranOpen = onVeteranOpen
    }

    var body: some View {
        return content
            .navigationTitle("feedback")
            .task { await viewModel.loadNames() }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.feedbackListUiState {
        case .loading:
            LoadingView()
        case .error:
            ErrorView()
        case .success(let items):
            List(items) { item in
                FeedbackCard(item: item, onVeteranOpen: onVeteranOpen, onAction: viewModel.onAction)
                    .swipeActions {
                        if !item.isReviewed {
                            Button {
                                viewModel.onAction(.markReviewed(feedbackId: item.id))
                            } label: {
                                Label("mark_as_reviewed", systemImage: "checkmark")
                            }
                            .tint(Palette.success)
                        }
                    }
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
