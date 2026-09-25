import Foundation

struct FeedbackUiData: Hashable {
    var isAboutVeteran = false
    var veteranName = ""
    var type = FeedbackType.other
    var text = ""
    var contact = ""
    var hasTextProfanity = false
    var hasContactProfanity = false
    var status = FormStatus.editing

    var canSend: Bool {
        return !text.isBlank && status != .sending
    }
}
