import Foundation

@Observable
final class SubmissionViewModel {
    private static let maxTextLength = 5000

    private(set) var submissionUiData = SubmissionUiData()

    @ObservationIgnored private let veteranId: String
    @ObservationIgnored private let submissionsRepository: SubmissionsRepository
    @ObservationIgnored private let veteransRepository: VeteransRepository
    @ObservationIgnored private let contentCheckRepository: ContentCheckRepository

    init(
        veteranId: String,
        submissionsRepository: SubmissionsRepository,
        veteransRepository: VeteransRepository,
        contentCheckRepository: ContentCheckRepository
    ) {
        self.veteranId = veteranId
        self.submissionsRepository = submissionsRepository
        self.veteransRepository = veteransRepository
        self.contentCheckRepository = contentCheckRepository
    }

    func loadVeteranName() async {
        let veterans = (try? await veteransRepository.allVeterans()) ?? []
        submissionUiData.veteranName = veterans.first { return $0.id == veteranId }?.name ?? ""
    }

    func onAction(_ action: SubmissionUserAction) {
        switch action {
        case .textChanged(let text):
            submissionUiData.text = String(text.prefix(Self.maxTextLength))
            submissionUiData.hasTextProfanity = false
        case .contactChanged(let contact):
            submissionUiData.contact = contact
            submissionUiData.hasContactProfanity = false
        case .consentChanged(let hasConsent):
            submissionUiData.hasConsent = hasConsent
        case .photosPicked(let photos):
            checkPhotos(photos)
        case .photoRemoved(let id):
            submissionUiData.photos.removeAll { return $0.id == id }
        case .send:
            send()
        }
    }

    private func checkPhotos(_ photos: [Data]) {
        let accepted = Array(photos.prefix(submissionUiData.remainingPhotoSlots))
        submissionUiData.checkingPhotosCount += accepted.count
        submissionUiData.photoRejection = nil
        for data in accepted {
            Task {
                let result = await contentCheckRepository.checkPhoto(data)
                submissionUiData.checkingPhotosCount -= 1
                if result == .allowed {
                    submissionUiData.photos.append(PickedPhoto(id: UUID(), data: data))
                } else {
                    submissionUiData.photoRejection = result
                }
            }
        }
    }

    private func send() {
        let data = submissionUiData
        guard data.canSend else {
            return
        }
        let hasTextProfanity = contentCheckRepository.containsProfanity(data.text)
        let hasContactProfanity = contentCheckRepository.containsProfanity(data.contact)
        guard !hasTextProfanity && !hasContactProfanity else {
            submissionUiData.hasTextProfanity = hasTextProfanity
            submissionUiData.hasContactProfanity = hasContactProfanity
            return
        }
        submissionUiData.status = .sending
        Task {
            do {
                try await submissionsRepository.submit(SubmissionDraft(
                    veteranId: veteranId,
                    text: data.text.trimmed,
                    contact: data.contact.trimmed,
                    photos: data.photos.map(\.data)
                ))
                submissionUiData.status = .sent
            } catch {
                submissionUiData.status = .failed
            }
        }
    }
}
