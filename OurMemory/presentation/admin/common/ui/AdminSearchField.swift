import SwiftUI

struct AdminSearchField: View {
    let placeholder: LocalizedStringKey
    @Binding var text: String

    var body: some View {
        return HStack(spacing: Spacing.m) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Palette.onSurfaceVariant)
            TextField(placeholder, text: $text)
                .appStyle(.bodyLarge)
                .autocorrectionDisabled()
        }
        .padding(.horizontal, Spacing.xl)
        .padding(.vertical, Spacing.l)
        .background(Capsule().fill(Palette.containerHigh))
    }
}
