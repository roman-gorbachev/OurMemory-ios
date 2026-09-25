import SwiftUI

struct SubmissionReviewRoute: View {
    @State private var viewModel: SubmissionReviewViewModel
    let onClose: () -> Void

    init(viewModel: SubmissionReviewViewModel, onClose: @escaping () -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onClose = onClose
    }

    var body: some View {
        return content
            .navigationTitle("moderation")
            .navigationBarTitleDisplayMode(.inline)
            .task { await viewModel.load() }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.submissionReviewUiState {
        case .loading:
            LoadingView()
        case .error:
            ErrorView()
        case .success(let data):
            SubmissionReviewScreen(data: data, onAction: viewModel.onAction)
                .onChange(of: data.isFinished) { _, isFinished in
                    if isFinished {
                        onClose()
                    }
                }
        }
    }
}
