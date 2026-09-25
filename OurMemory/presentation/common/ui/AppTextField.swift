import SwiftUI

struct AppTextField: View {
    private static let borderWidth: CGFloat = 1
    private static let focusedBorderWidth: CGFloat = 2

    let label: LocalizedStringKey
    @Binding var text: String
    var axis = Axis.horizontal
    var minLines = 1
    var isError = false
    var supportingText: LocalizedStringKey?
    var keyboard = UIKeyboardType.default
    var isSecure = false
    @FocusState private var isFocused: Bool

    var body: some View {
        return VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(label)
                .appStyle(.labelMedium)
                .foregroundStyle(isError ? Palette.error : Palette.onSurfaceVariant)
            field
                .appStyle(.bodyLarge)
                .foregroundStyle(Palette.onSurface)
                .keyboardType(keyboard)
                .focused($isFocused)
                .padding(Spacing.l)
                .background(RoundedRectangle(cornerRadius: CornerRadius.small).fill(Palette.surface))
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.small)
                        .stroke(borderColor, lineWidth: isFocused ? Self.focusedBorderWidth : Self.borderWidth)
                )
            if let supportingText {
                Text(supportingText)
                    .appStyle(.bodySmall)
                    .foregroundStyle(isError ? Palette.error : Palette.onSurfaceVariant)
            }
        }
    }

    @ViewBuilder
    private var field: some View {
        if isSecure {
            SecureField("", text: $text)
        } else {
            TextField("", text: $text, axis: axis)
                .lineLimit(minLines...)
        }
    }

    private var borderColor: Color {
        if isError {
            return Palette.error
        }
        return isFocused ? Palette.primary : Palette.outline
    }
}

#Preview {
    AppTextField(label: "email", text: .constant("admin@memory.by"))
        .padding()
}
