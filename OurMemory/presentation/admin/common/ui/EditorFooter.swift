import SwiftUI

struct EditorFooter: View {
    let status: EditorStatus
    let canSave: Bool
    let deleteMessage: LocalizedStringKey?
    let onSave: () -> Void
    let onDelete: () -> Void
    @State private var isDeleteConfirmationPresented = false

    var body: some View {
        return VStack(spacing: Spacing.m) {
            if status.hasFailed {
                Text("failed_to_save_msg")
                    .appStyle(.bodyMedium)
                    .foregroundStyle(Palette.error)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            if status.isUploading {
                Text("uploading_file")
                    .appStyle(.bodyMedium)
                    .foregroundStyle(Palette.onSurfaceVariant)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            AppButton(title: "save", isLoading: status.isSaving, action: onSave)
                .disabled(!canSave)
            if let deleteMessage {
                Button("delete", role: .destructive) {
                    isDeleteConfirmationPresented = true
                }
                .appStyle(.labelLarge, weight: .semibold)
                .foregroundStyle(Palette.error)
                .disabled(status.isBusy)
                .alert(deleteMessage, isPresented: $isDeleteConfirmationPresented) {
                    Button("delete", role: .destructive, action: onDelete)
                    Button("cancel", role: .cancel) {}
                }
            }
        }
    }
}
