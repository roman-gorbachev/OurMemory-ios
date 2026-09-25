import SwiftUI

struct AccountRow: View {
    private static let avatarSize: CGFloat = 56

    let account: VisitorAccount?
    let signInStatus: SignInStatus
    let onSignIn: () -> Void
    let onSignOut: () -> Void

    var body: some View {
        if let account {
            HStack(spacing: Spacing.l) {
                PortraitImage(url: account.photoUrl)
                    .frame(width: Self.avatarSize, height: Self.avatarSize)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(verbatim: account.name.isBlank ? account.email : account.name)
                        .appStyle(.title3, weight: .semibold)
                        .lineLimit(1)
                    Text(verbatim: account.email)
                        .appStyle(.subheadline)
                        .foregroundStyle(Palette.onSurfaceVariant)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Button("sign_out", role: .destructive, action: onSignOut)
                    .buttonStyle(.borderless)
            }
        } else {
            VStack(alignment: .leading, spacing: Spacing.l) {
                Label {
                    Text("keep_your_memory_safe")
                        .appStyle(.headline)
                } icon: {
                    Image(systemName: "icloud.fill")
                        .foregroundStyle(Palette.primary)
                }
                Button(action: onSignIn) {
                    HStack {
                        if signInStatus == .inProgress {
                            ProgressView()
                        } else {
                            Image(systemName: "person.crop.circle.badge.checkmark")
                        }
                        Text("sign_in_with_google")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .disabled(signInStatus == .inProgress)
                if signInStatus == .failed {
                    Text("could_not_sign_in_msg")
                        .appStyle(.footnote)
                        .foregroundStyle(Palette.error)
                }
            }
            .padding(.vertical, Spacing.xs)
        }
    }
}
