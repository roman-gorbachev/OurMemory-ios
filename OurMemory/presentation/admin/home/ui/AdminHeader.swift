import SwiftUI

struct AdminHeader: View {
    private static let cornerRadius: CGFloat = 28
    private static let padding: CGFloat = 20
    private static let titleIconSize: CGFloat = 28
    private static let avatarSize: CGFloat = 36
    private static let avatarOpacity = 0.2
    private static let subtitleOpacity = 0.9
    private static let subtitleLines = 2

    let email: String
    let onSignOut: () -> Void

    var body: some View {
        return VStack(alignment: .leading, spacing: Spacing.l) {
            HStack(spacing: Spacing.l) {
                Image(systemName: "shield.fill")
                    .font(.system(size: Self.titleIconSize))
                Text("administration")
                    .appStyle(.titleMedium, weight: .bold)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button(action: onSignOut) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                }
                .accessibilityLabel("sign_out")
            }
            HStack(spacing: Spacing.l) {
                Text(verbatim: String(email.prefix(1)).uppercased())
                    .appStyle(.titleMedium, weight: .bold)
                    .frame(width: Self.avatarSize, height: Self.avatarSize)
                    .background(Circle().fill(Palette.white.opacity(Self.avatarOpacity)))
                Text(verbatim: L10n.format("signed_in_as", email))
                    .appStyle(.bodyMedium)
                    .opacity(Self.subtitleOpacity)
                    .lineLimit(Self.subtitleLines)
            }
        }
        .foregroundStyle(Palette.white)
        .padding(Self.padding)
        .background(
            RoundedRectangle(cornerRadius: Self.cornerRadius)
                .fill(LinearGradient(colors: [Palette.brandRed, Palette.brandBrightRed], startPoint: .topLeading, endPoint: .bottomTrailing))
        )
    }
}
