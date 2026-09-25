import SwiftUI

struct AddAdminSheet: View {
    let status: AddAdminStatus
    let onAdd: (String) -> Void
    @State private var email = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        return NavigationStack {
            Form {
                Section {
                    TextField("email", text: $email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .onSubmit { onAdd(email) }
                } footer: {
                    if let messageKey = status.messageKey {
                        Text(messageKey)
                            .foregroundStyle(status == .added ? Palette.success : Palette.error)
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .disabled(status == .adding)
            .navigationTitle("add_administrator")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("done") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if status == .adding {
                        ProgressView()
                    } else {
                        Button("add_administrator") { onAdd(email) }
                            .disabled(email.isBlank)
                    }
                }
            }
        }
    }
}

#Preview {
    AddAdminSheet(status: .accountNotFound) { _ in }
}
