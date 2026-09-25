import SwiftUI

struct VeteranEditorRoute: View {
    @State private var viewModel: VeteranEditorViewModel
    let onClose: () -> Void

    init(viewModel: VeteranEditorViewModel, onClose: @escaping () -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onClose = onClose
    }

    var body: some View {
        return content
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .task { await viewModel.load() }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.veteranEditorUiState {
        case .loading:
            LoadingView()
        case .error:
            ErrorView()
        case .editing(let data):
            VeteranEditorForm(data: data, onAction: viewModel.onAction)
                .toolbar {
                    EditorToolbar(status: data.status, canSave: data.canSave) { viewModel.onAction(.save) }
                }
                .onChange(of: data.status.isClosed) { _, isClosed in
                    if isClosed {
                        onClose()
                    }
                }
        }
    }

    private var title: String {
        guard case .editing(let data) = viewModel.veteranEditorUiState else {
            return ""
        }
        return data.isNew ? L10n.string("new_veteran") : data.form.name
    }
}
