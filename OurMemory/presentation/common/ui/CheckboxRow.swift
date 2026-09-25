import SwiftUI

struct CheckboxRow: View {
    let title: LocalizedStringKey
    let isChecked: Bool
    let onToggle: () -> Void

    var body: some View {
        return Button(action: onToggle) {
            HStack(alignment: .top, spacing: Spacing.l) {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .font(.title3)
                    .foregroundStyle(isChecked ? Palette.primary : Palette.onSurfaceVariant)
                Text(title)
                    .appStyle(.bodyMedium)
                    .foregroundStyle(Palette.onSurface)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CheckboxRow(title: "consent_to_contact_msg", isChecked: true) {}
        .padding()
}
