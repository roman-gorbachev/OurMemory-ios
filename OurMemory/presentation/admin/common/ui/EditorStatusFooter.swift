import SwiftUI

struct EditorStatusFooter: View {
    let status: EditorStatus

    var body: some View {
        if let failure = status.failure {
            Text(failure.messageKey).foregroundStyle(Palette.error)
        } else if status.isUploading {
            HStack(spacing: Spacing.m) {
                ProgressView()
                Text("uploading_file")
            }
        }
    }
}
