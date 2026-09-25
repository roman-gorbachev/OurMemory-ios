import SwiftUI

struct DeleteSection: View {
    let message: LocalizedStringKey
    let isDisabled: Bool
    let onDelete: () -> Void
    @State private var isConfirmationPresented = false

    var body: some View {
        return Section {
            Button("delete", role: .destructive) {
                isConfirmationPresented = true
            }
            .frame(maxWidth: .infinity)
            .disabled(isDisabled)
            .confirmationDialog(message, isPresented: $isConfirmationPresented, titleVisibility: .visible) {
                Button("delete", role: .destructive, action: onDelete)
            }
        }
    }
}
