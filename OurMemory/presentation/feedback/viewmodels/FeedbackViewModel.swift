import Foundation

@Observable
final class FeedbackViewModel {
    private static let maxTextLength = 3000

    private(set) var feedbackUiData: FeedbackUiData

    @ObservationIgnored private let veteranId: String
    @ObservationIgnored private let feedbackRepository: FeedbackRepository
    @ObservationIgnored private let veteransRepository: VeteransRepository
    @ObservationIgnored private let contentCheckRepository: ContentCheckRepository

    init(
        veteranId: String,
        feedbackRepository: FeedbackRepository,
        veteransRepository: VeteransRepository,
        contentCheckRepository: ContentCheckRepository
    ) {
        self.veteranId = veteranId
        self.feedbackRepository = feedbackRepository
        self.veteransRepository = veteransRepository
        self.contentCheckRepository = contentCheckRepository
        feedbackUiData = FeedbackUiData(isAboutVeteran: !veteranId.isEmpty, type: veteranId.isEmpty ? .other : .dataError)
    }

    func loadVeteranName() async {
        guard !veteranId.isEmpty else {
            return
        }
        let veterans = (try? await veteransRepository.allVeterans()) ?? []
        feedbackUiData.veteranName = veterans.first { return $0.id == veteranId }?.name ?? ""
    }

    func onAction(_ action: FeedbackUserAction) {
        switch action {
        case .typeChanged(let type):
            feedbackUiData.type = type
        case .textChanged(let text):
            feedbackUiData.text = String(text.prefix(Self.maxTextLength))
            feedbackUiData.hasTextProfanity = false
        case .contactChanged(let contact):
            feedbackUiData.contact = contact
            feedbackUiData.hasContactProfanity = false
        case .send:
            send()
        }
    }

    private func send() {
        let data = feedbackUiData
        guard data.canSend else {
            return
        }
        let hasTextProfanity = contentCheckRepository.containsProfanity(data.text)
        let hasContactProfanity = contentCheckRepository.containsProfanity(data.contact)
        guard !hasTextProfanity && !hasContactProfanity else {
            feedbackUiData.hasTextProfanity = hasTextProfanity
            feedbackUiData.hasContactProfanity = hasContactProfanity
            return
        }
        feedbackUiData.status = .sending
        Task {
            do {
                try await feedbackRepository.send(FeedbackDraft(
                    type: data.type,
                    text: data.text.trimmed,
                    contact: data.contact.trimmed,
                    veteranId: veteranId
                ))
                feedbackUiData.status = .sent
            } catch {
                feedbackUiData.status = .failed
            }
        }
    }
}
