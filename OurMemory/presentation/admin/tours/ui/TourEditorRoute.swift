import SwiftUI

struct TourEditorRoute: View {
    @State private var viewModel: TourEditorViewModel
    let onClose: () -> Void

    init(viewModel: TourEditorViewModel, onClose: @escaping () -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onClose = onClose
    }

    var body: some View {
        return content
            .navigationTitle(isNew ? "new_tour" : "tour")
            .navigationBarTitleDisplayMode(.inline)
            .task { await viewModel.load() }
    }

    private var isNew: Bool {
        if case .editing(let data) = viewModel.tourEditorUiState {
            return data.isNew
        }
        return false
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.tourEditorUiState {
        case .loading:
            LoadingView()
        case .error:
            ErrorView()
        case .editing(let data):
            TourEditorScreen(data: data, onAction: viewModel.onAction)
                .toolbar {
                    EditorToolbar(status: data.status, canSave: data.canSave) { viewModel.onAction(.save) }
                }
                .editorFailureAlert(data.status.failure, uid: data.currentUid) { viewModel.onAction(.failureDismissed) }
                .onChange(of: data.status.isClosed) { _, isClosed in
                    if isClosed {
                        onClose()
                    }
                }
        }
    }
}
