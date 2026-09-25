import Foundation

struct EditorStatus: Hashable {
    var uploads = 0
    var isSaving = false
    var failure: EditorFailure?
    var isClosed = false

    var isUploading: Bool {
        return uploads > 0
    }

    var isBusy: Bool {
        return isUploading || isSaving
    }
}
