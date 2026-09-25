import SwiftUI

struct EditorToolbar: ToolbarContent {
    let status: EditorStatus
    let canSave: Bool
    let onSave: () -> Void

    var body: some ToolbarContent {
        return ToolbarItem(placement: .confirmationAction) {
            if status.isSaving {
                ProgressView()
            } else {
                Button("save", action: onSave)
                    .disabled(!canSave)
            }
        }
    }
}
