import SwiftUI

struct HomeRoute: View {
    @State private var viewModel: HomeViewModel
    @State private var isScannerPresented = false
    let makeScanViewModel: () -> VeteranScanViewModel
    let onVeteranOpen: (String) -> Void

    init(
        viewModel: HomeViewModel,
        makeScanViewModel: @escaping () -> VeteranScanViewModel,
        onVeteranOpen: @escaping (String) -> Void
    ) {
        _viewModel = State(initialValue: viewModel)
        self.makeScanViewModel = makeScanViewModel
        self.onVeteranOpen = onVeteranOpen
    }

    var body: some View {
        return content
            .navigationTitle("app_name")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isScannerPresented = true
                    } label: {
                        Label("scan_qr_code_or_name", systemImage: "text.viewfinder")
                    }
                }
            }
            .task { await viewModel.load() }
            .veteranScanner(isPresented: $isScannerPresented, makeViewModel: makeScanViewModel, onVeteranScanned: onVeteranOpen)
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.homeUiState {
        case .loading:
            LoadingView()
        case .error:
            ErrorView()
        case .success(let data):
            HomeScreen(data: data, onAction: viewModel.onAction, onVeteranOpen: onVeteranOpen)
        }
    }
}
