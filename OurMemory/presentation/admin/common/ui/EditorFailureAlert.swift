import SwiftUI
import UIKit

struct EditorFailureAlert: ViewModifier {
    let failure: EditorFailure?
    let uid: String
    let onDismiss: () -> Void

    func body(content: Content) -> some View {
        return content.alert(
            failure?.messageKey ?? "",
            isPresented: Binding(get: { return failure != nil }, set: { if !$0 { onDismiss() } })
        ) {
            if failure == .uploadDenied && !uid.isEmpty {
                Button("copy_uid") {
                    UIPasteboard.general.string = uid
                    onDismiss()
                }
            }
            Button("done", role: .cancel, action: onDismiss)
        } message: {
            if failure == .uploadDenied && !uid.isEmpty {
                Text(verbatim: "UID: \(uid)")
            }
        }
    }
}

extension View {
    func editorFailureAlert(_ failure: EditorFailure?, uid: String, onDismiss: @escaping () -> Void) -> some View {
        return modifier(EditorFailureAlert(failure: failure, uid: uid, onDismiss: onDismiss))
    }
}
