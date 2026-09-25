import SwiftUI

struct VeteranEditorRoute: View {
    @State private var viewModel: VeteranEditorViewModel
    let onBack: () -> Void

    init(viewModel: VeteranEditorViewModel, onBack: @escaping () -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onBack = onBack
    }

    var body: some View {
        return TopBarContainer(title: title, onBack: onBack) {
            switch viewModel.veteranEditorUiState {
            case .loading:
                LoadingView()
            case .error:
                ErrorView()
            case .editing(let data):
                VeteranEditorScreen(data: data, onAction: viewModel.onAction)
                    .onChange(of: data.status.isClosed) { _, isClosed in
                        if isClosed {
                            onBack()
                        }
                    }
            }
        }
        .task { await viewModel.load() }
    }

    private var title: String {
        guard case .editing(let data) = viewModel.veteranEditorUiState else {
            return ""
        }
        return data.isNew ? L10n.string("new_veteran") : data.form.name
    }
}
