import SwiftUI

struct EditorStatusFooter: View {
    let status: EditorStatus

    var body: some View {
        if status.hasFailed {
            Text("failed_to_save_msg").foregroundStyle(Palette.error)
        } else if status.isUploading {
            HStack(spacing: Spacing.m) {
                ProgressView()
                Text("uploading_file")
            }
        }
    }
}
