import SwiftUI

struct ModerationListRoute: View {
    @State private var viewModel: ModerationListViewModel
    let onBack: () -> Void
    let onSubmissionOpen: (String) -> Void

    init(viewModel: ModerationListViewModel, onBack: @escaping () -> Void, onSubmissionOpen: @escaping (String) -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onBack = onBack
        self.onSubmissionOpen = onSubmissionOpen
    }

    var body: some View {
        return TopBarContainer(title: L10n.string("moderation"), onBack: onBack) {
            switch viewModel.moderationListUiState {
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
                            SubmissionCard(item: item) { onSubmissionOpen(item.id) }
                        }
                    }
                    .padding(Spacing.screen)
                }
            }
        }
        .task { await viewModel.loadNames() }
    }
}
