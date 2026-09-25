import SwiftUI

struct AdminLoginRoute: View {
    private static let heroIconSize: CGFloat = 56

    @State private var viewModel: AdminLoginViewModel
    let onSignedIn: () -> Void

    init(viewModel: AdminLoginViewModel, onSignedIn: @escaping () -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onSignedIn = onSignedIn
    }

    var body: some View {
        let data = viewModel.adminLoginUiData
        return Form {
            Section {
                VStack(spacing: Spacing.m) {
                    Image(systemName: "checkmark.shield.fill")
                        .font(.system(size: Self.heroIconSize))
                        .foregroundStyle(Palette.primary)
                    Text("administration")
                        .appStyle(.title2, weight: .bold)
                    Text("for_cemetery_editors_msg")
                        .appStyle(.subheadline)
                        .foregroundStyle(Palette.onSurfaceVariant)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.clear)
            }
            Section {
                TextField("email", text: Binding(get: { return data.email }, set: { viewModel.onAction(.emailChanged($0)) }))
                    .keyboardType(.emailAddress)
                    .textContentType(.username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                SecureField("password", text: Binding(get: { return data.password }, set: { viewModel.onAction(.passwordChanged($0)) }))
                    .textContentType(.password)
                    .onSubmit { viewModel.onAction(.signIn) }
            } footer: {
                if let error = data.error {
                    Text(error.messageKey).foregroundStyle(Palette.error)
                }
            }
            Section {
                Button {
                    viewModel.onAction(.signIn)
                } label: {
                    HStack {
                        Spacer()
                        if data.isSigningIn {
                            ProgressView()
                        } else {
                            Text("sign_in").bold()
                        }
                        Spacer()
                    }
                }
                .disabled(!data.canSignIn)
            }
        }
        .disabled(data.isSigningIn)
        .navigationTitle("sign_in_as_admin")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: data.isSignedIn) { _, isSignedIn in
            if isSignedIn {
                onSignedIn()
            }
        }
    }
}
