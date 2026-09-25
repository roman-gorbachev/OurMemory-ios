import SwiftUI

struct BurialEditorRoute: View {
    @State private var viewModel: BurialEditorViewModel
    let onBack: () -> Void

    init(viewModel: BurialEditorViewModel, onBack: @escaping () -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onBack = onBack
    }

    var body: some View {
        return TopBarContainer(title: L10n.string(isNew ? "new_burial_place" : "burial_place"), onBack: onBack) {
            switch viewModel.burialEditorUiState {
            case .loading:
                LoadingView()
            case .error:
                ErrorView()
            case .editing(let data):
                BurialEditorScreen(data: data, onAction: viewModel.onAction)
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
        if case .editing(let data) = viewModel.burialEditorUiState {
            return data.isNew
        }
        return false
    }
}
