import SwiftUI

struct TourRoute: View {
    @State private var viewModel: TourViewModel
    let onBack: () -> Void

    init(viewModel: TourViewModel, onBack: @escaping () -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onBack = onBack
    }

    var body: some View {
        return content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Palette.background.ignoresSafeArea())
            .overlay(alignment: .topLeading) {
                CircleIconButton(systemImage: "chevron.left", accessibilityLabel: "back", action: onBack)
                    .padding(Spacing.l)
            }
            .toolbar(.hidden, for: .navigationBar)
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
