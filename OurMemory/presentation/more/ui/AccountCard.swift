import SwiftUI

struct AccountCard: View {
    private static let avatarSize: CGFloat = 48
    private static let nameLines = 1

    let account: VisitorAccount?
    let signInStatus: SignInStatus
    let onSignIn: () -> Void
    let onSignOut: () -> Void

    var body: some View {
        return Group {
            if let account {
                signedIn(account)
            } else {
                signedOut
            }
        }
        .padding(Spacing.xl)
        .background(RoundedRectangle(cornerRadius: CornerRadius.group).fill(Palette.containerLow))
    }

    private var signedOut: some View {
        return VStack(alignment: .leading, spacing: Spacing.l) {
            HStack(spacing: Spacing.l) {
                Image(systemName: "checkmark.icloud")
                    .foregroundStyle(Palette.primary)
                    .frame(width: Self.avatarSize, height: Self.avatarSize)
                    .background(Circle().fill(Palette.primaryContainer))
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text("keep_your_memory_safe")
                        .appStyle(.titleMedium, weight: .bold)
                        .foregroundStyle(Palette.onSurface)
                    Text("sign_in_to_keep_favorites_msg")
                        .appStyle(.bodySmall)
                        .foregroundStyle(Palette.onSurfaceVariant)
                }
            }
            AppButton(
                title: "sign_in_with_google",
                systemImage: "g.circle",
                kind: .outlined,
                isLoading: signInStatus == .inProgress,
                action: onSignIn
            )
            .disabled(signInStatus == .inProgress)
            if signInStatus == .failed {
                Text("could_not_sign_in_msg")
                    .appStyle(.bodySmall)
                    .foregroundStyle(Palette.error)
            }
        }
    }

    private func signedIn(_ account: VisitorAccount) -> some View {
        return HStack(spacing: Spacing.l) {
            PortraitImage(url: account.photoUrl)
                .frame(width: Self.avatarSize, height: Self.avatarSize)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(verbatim: account.name.isBlank ? account.email : account.name)
                    .appStyle(.titleMedium, weight: .bold)
                    .foregroundStyle(Palette.onSurface)
                    .lineLimit(Self.nameLines)
                Text("favorites_and_requests_are_saved_msg")
                    .appStyle(.bodySmall)
                    .foregroundStyle(Palette.onSurfaceVariant)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Button("sign_out", action: onSignOut)
                .appStyle(.labelLarge, weight: .semibold)
                .foregroundStyle(Palette.primary)
        }
    }
}

#Preview {
    AccountCard(account: nil, signInStatus: .idle, onSignIn: {}, onSignOut: {})
        .padding()
}
