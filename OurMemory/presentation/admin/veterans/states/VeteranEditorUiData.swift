import Foundation

struct VeteranEditorUiData: Hashable {
    let form: VeteranForm
    let burials: [BurialUi]
    let isNew: Bool
    let status: EditorStatus

    var canSave: Bool {
        return form.isValid && !status.isBusy
    }
}
