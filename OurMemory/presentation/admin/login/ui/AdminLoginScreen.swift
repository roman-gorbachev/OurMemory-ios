import SwiftUI

struct AdminLoginScreen: View {
    private static let heroIconContainer: CGFloat = 72
    private static let heroIconSize: CGFloat = 36

    let data: AdminLoginUiData
    let onAction: (AdminLoginUserAction) -> Void

    var body: some View {
        return ScrollView {
            VStack(spacing: Spacing.xl) {
                VStack(spacing: Spacing.m) {
                    Image(systemName: "shield")
                        .font(.system(size: Self.heroIconSize))
                        .foregroundStyle(Palette.primary)
                        .frame(width: Self.heroIconContainer, height: Self.heroIconContainer)
                        .background(Circle().fill(Palette.primaryContainer))
                    Text("administration")
                        .appStyle(.headlineSmall, weight: .bold)
                        .foregroundStyle(Palette.onSurface)
                    Text("for_cemetery_editors_msg")
                        .appStyle(.bodyMedium)
                        .foregroundStyle(Palette.onSurfaceVariant)
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, Spacing.m)
                VStack(alignment: .leading, spacing: Spacing.l) {
                    AppTextField(
                        label: "email",
                        text: Binding(get: { return data.email }, set: { onAction(.emailChanged($0)) }),
                        keyboard: .emailAddress
                    )
                    .textInputAutocapitalization(.never)
                    AppTextField(
                        label: "password",
                        text: Binding(get: { return data.password }, set: { onAction(.passwordChanged($0)) }),
                        isSecure: true
                    )
                    .onSubmit { onAction(.signIn) }
                    if let error = data.error {
                        Text(error.messageKey)
                            .appStyle(.bodyMedium)
                            .foregroundStyle(Palette.error)
                    }
                }
                .disabled(data.isSigningIn)
                .padding(Spacing.xl)
                .background(RoundedRectangle(cornerRadius: CornerRadius.group).fill(Palette.containerLow))
                AppButton(title: "sign_in", isLoading: data.isSigningIn) { onAction(.signIn) }
                    .disabled(!data.canSignIn)
            }
            .padding(Spacing.screen)
        }
        .scrollDismissesKeyboard(.interactively)
    }
}

#Preview {
    AdminLoginScreen(data: AdminLoginUiData(error: .wrongCredentials), onAction: { _ in })
}
