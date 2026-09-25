import Foundation

struct SubmissionUiData: Hashable {
    static let maxPhotos = 5

    var veteranName = ""
    var text = ""
    var contact = ""
    var photos: [PickedPhoto] = []
    var checkingPhotosCount = 0
    var photoRejection: PhotoCheckResult?
    var hasTextProfanity = false
    var hasContactProfanity = false
    var hasConsent = false
    var status = FormStatus.editing

    var canSend: Bool {
        return !text.isBlank && !contact.isBlank && hasConsent && checkingPhotosCount == 0 && status != .sending
    }

    var canAddPhotos: Bool {
        return photos.count + checkingPhotosCount < Self.maxPhotos && status != .sending
    }

    var remainingPhotoSlots: Int {
        return max(Self.maxPhotos - photos.count - checkingPhotosCount, 0)
    }
}
