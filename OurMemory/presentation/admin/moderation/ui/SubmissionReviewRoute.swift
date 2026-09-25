import SwiftUI

struct SubmissionReviewRoute: View {
    @State private var viewModel: SubmissionReviewViewModel
    let onBack: () -> Void

    init(viewModel: SubmissionReviewViewModel, onBack: @escaping () -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onBack = onBack
    }

    var body: some View {
        return TopBarContainer(title: L10n.string("moderation"), onBack: onBack) {
            switch viewModel.submissionReviewUiState {
            case .loading:
                LoadingView()
            case .error:
                ErrorView()
            case .success(let data):
                SubmissionReviewScreen(data: data, onAction: viewModel.onAction)
                    .onChange(of: data.isFinished) { _, isFinished in
                        if isFinished {
                            onBack()
                        }
                    }
            }
        }
        .task { await viewModel.load() }
    }
}
