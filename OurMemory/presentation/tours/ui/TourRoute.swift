import SwiftUI

struct TourRoute: View {
    @State private var viewModel: TourViewModel

    init(viewModel: TourViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        return content
            .navigationBarTitleDisplayMode(.inline)
            .task { await viewModel.load() }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.tourUiState {
        case .loading:
            LoadingView()
        case .error:
            ErrorView()
        case .success(let data):
            TourScreen(data: data, playbackState: viewModel.playbackState, onAction: viewModel.onAction)
        }
    }
}
