import SwiftUI

struct MoreRoute: View {
    @State private var viewModel: MoreViewModel
    @State private var isScannerPresented = false
    let onWriteToUs: () -> Void
    let onMyRequests: () -> Void
    let onFavorites: () -> Void
    let onVeteranOpen: (String) -> Void
    let onAdmin: () -> Void

    init(
        viewModel: MoreViewModel,
        onWriteToUs: @escaping () -> Void,
        onMyRequests: @escaping () -> Void,
        onFavorites: @escaping () -> Void,
        onVeteranOpen: @escaping (String) -> Void,
        onAdmin: @escaping () -> Void
    ) {
        _viewModel = State(initialValue: viewModel)
        self.onWriteToUs = onWriteToUs
        self.onMyRequests = onMyRequests
        self.onFavorites = onFavorites
        self.onVeteranOpen = onVeteranOpen
        self.onAdmin = onAdmin
    }

    var body: some View {
        return MoreScreen(
            data: viewModel.moreUiData,
            onAction: viewModel.onAction,
            onGoogleSignIn: {
                viewModel.onAction(.googleSignInStarted)
                Task { viewModel.onAction(await GoogleSignInLauncher.signIn()) }
            },
            onWriteToUs: onWriteToUs,
            onMyRequests: onMyRequests,
            onFavorites: onFavorites,
            onScanQr: { isScannerPresented = true },
            onAdmin: onAdmin
        )
        .navigationTitle("more")
        .qrScanner(isPresented: $isScannerPresented, onVeteranScanned: onVeteranOpen)
    }
}
