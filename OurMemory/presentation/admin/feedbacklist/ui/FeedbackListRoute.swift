import SwiftUI

struct FeedbackListRoute: View {
    @State private var viewModel: FeedbackListViewModel
    let onBack: () -> Void
    let onVeteranOpen: (String) -> Void

    init(viewModel: FeedbackListViewModel, onBack: @escaping () -> Void, onVeteranOpen: @escaping (String) -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onBack = onBack
        self.onVeteranOpen = onVeteranOpen
    }

    var body: some View {
        return TopBarContainer(title: L10n.string("feedback"), onBack: onBack) {
            switch viewModel.feedbackListUiState {
            case .loading:
                LoadingView()
            case .error:
                ErrorView()
            case .success(let items):
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: Spacing.l) {
                        if items.isEmpty {
                            EmptyListText()
                        }
                        ForEach(items) { item in
                            FeedbackCard(item: item, onVeteranOpen: onVeteranOpen, onAction: viewModel.onAction)
                        }
                    }
                    .padding(Spacing.screen)
                }
            }
        }
        .task { await viewModel.loadNames() }
    }
}
