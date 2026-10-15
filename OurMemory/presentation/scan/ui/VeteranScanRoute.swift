import SwiftUI

struct VeteranScanRoute: View {
    @State private var viewModel: VeteranScanViewModel
    let onQrScanned: (String) -> Void
    let onVeteranOpen: (String) -> Void

    init(
        viewModel: VeteranScanViewModel,
        onQrScanned: @escaping (String) -> Void,
        onVeteranOpen: @escaping (String) -> Void
    ) {
        _viewModel = State(initialValue: viewModel)
        self.onQrScanned = onQrScanned
        self.onVeteranOpen = onVeteranOpen
    }

    var body: some View {
        return VeteranScanScreen(
            data: data,
            onQrScanned: onQrScanned,
            onTextRecognized: { viewModel.onAction(.textRecognized($0)) },
            onVeteranOpen: onVeteranOpen
        )
        .task { await viewModel.load() }
    }

    private var data: VeteranScanUiData {
        switch viewModel.veteranScanUiState {
        case .loading, .error:
            return VeteranScanUiData(candidates: [], hasRecognizedText: false)
        case .success(let data):
            return data
        }
    }
}
