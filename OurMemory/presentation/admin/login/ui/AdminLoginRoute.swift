import SwiftUI

struct AdminLoginRoute: View {
    @State private var viewModel: AdminLoginViewModel
    let onBack: () -> Void
    let onSignedIn: () -> Void

    init(viewModel: AdminLoginViewModel, onBack: @escaping () -> Void, onSignedIn: @escaping () -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onBack = onBack
        self.onSignedIn = onSignedIn
    }

    var body: some View {
        return TopBarContainer(title: L10n.string("sign_in_as_admin"), onBack: onBack) {
            AdminLoginScreen(data: viewModel.adminLoginUiData, onAction: viewModel.onAction)
        }
        .onChange(of: viewModel.adminLoginUiData.isSignedIn) { _, isSignedIn in
            if isSignedIn {
                onSignedIn()
            }
        }
    }
}
