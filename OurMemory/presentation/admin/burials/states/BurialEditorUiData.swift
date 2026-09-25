import Foundation

struct BurialEditorUiData: Hashable {
    let form: BurialForm
    let isNew: Bool
    let status: EditorStatus

    var canSave: Bool {
        return form.isValid && !status.isBusy
    }
}
