import SwiftUI

struct HomeRoute: View {
    @State private var viewModel: HomeViewModel
    @State private var isScannerPresented = false
    let onVeteranOpen: (String) -> Void

    init(viewModel: HomeViewModel, onVeteranOpen: @escaping (String) -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onVeteranOpen = onVeteranOpen
    }

    var body: some View {
        return content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Palette.background.ignoresSafeArea())
            .task { await viewModel.load() }
            .qrScanner(isPresented: $isScannerPresented, onVeteranScanned: onVeteranOpen)
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.homeUiState {
        case .loading:
            LoadingView()
        case .error:
            ErrorView()
        case .success(let data):
            HomeScreen(
                data: data,
                onAction: viewModel.onAction,
                onVeteranOpen: onVeteranOpen,
                onScanTap: { isScannerPresented = true }
            )
        }
    }
}
