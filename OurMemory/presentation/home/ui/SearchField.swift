import SwiftUI

struct SearchField: View {
    private static let cornerRadius: CGFloat = 14

    @Binding var text: String

    var body: some View {
        return HStack(spacing: Spacing.m) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Palette.onSurfaceVariant)
            TextField("search", text: $text)
                .appStyle(.bodyLarge)
                .submitLabel(.search)
                .autocorrectionDisabled()
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Palette.onSurfaceVariant)
                }
                .accessibilityLabel("clear")
            }
        }
        .padding(Spacing.xl)
        .background(RoundedRectangle(cornerRadius: Self.cornerRadius).fill(Palette.containerHigh))
    }
}

#Preview {
    SearchField(text: .constant(""))
        .padding()
}
