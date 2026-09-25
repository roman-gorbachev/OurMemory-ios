import SwiftUI

struct TourEditorRoute: View {
    @State private var viewModel: TourEditorViewModel
    let onBack: () -> Void

    init(viewModel: TourEditorViewModel, onBack: @escaping () -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onBack = onBack
    }

    var body: some View {
        return TopBarContainer(title: L10n.string(isNew ? "new_tour" : "tours"), onBack: onBack) {
            switch viewModel.tourEditorUiState {
            case .loading:
                LoadingView()
            case .error:
                ErrorView()
            case .editing(let data):
                TourEditorScreen(data: data, onAction: viewModel.onAction)
                    .onChange(of: data.status.isClosed) { _, isClosed in
                        if isClosed {
                            onBack()
                        }
                    }
            }
        }
        .task { await viewModel.load() }
    }

    private var isNew: Bool {
        if case .editing(let data) = viewModel.tourEditorUiState {
            return data.isNew
        }
        return false
    }
}
