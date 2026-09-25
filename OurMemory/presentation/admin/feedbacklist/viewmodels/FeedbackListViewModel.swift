import Combine
import Foundation

@Observable
final class FeedbackListViewModel {
    private(set) var feedbackListUiState = FeedbackListUiState.loading

    @ObservationIgnored private let feedbackRepository: FeedbackRepository
    @ObservationIgnored private let veteransRepository: VeteransRepository
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    @ObservationIgnored private var names: [String: String] = [:]
    @ObservationIgnored private var items: [Feedback]?

    init(feedbackRepository: FeedbackRepository, veteransRepository: VeteransRepository) {
        self.feedbackRepository = feedbackRepository
        self.veteransRepository = veteransRepository
        observeFeedbackListUiState()
    }

    func loadNames() async {
        names = await VeteranNamesLoader.names(from: veteransRepository)
        rebuild()
    }

    func onAction(_ action: FeedbackListUserAction) {
        switch action {
        case .markReviewed(let feedbackId):
            Task { try? await feedbackRepository.markReviewed(feedbackId: feedbackId) }
        case .reply(let feedbackId, let text):
            guard !text.isBlank else {
                return
            }
            Task { try? await feedbackRepository.reply(feedbackId: feedbackId, text: text.trimmed) }
        }
    }

    private func observeFeedbackListUiState() {
        feedbackRepository.feedbackPublisher()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure = completion {
                        self?.feedbackListUiState = .error
                    }
                },
                receiveValue: { [weak self] items in
                    self?.items = items
                    self?.rebuild()
                }
            )
            .store(in: &cancellables)
    }

    private func rebuild() {
        guard let items else {
            return
        }
        feedbackListUiState = .success(data: items.map { item in
            return FeedbackItemUi(
                id: item.id,
                type: item.type,
                text: item.text,
                contact: item.contact,
                veteranId: item.veteranId,
                veteranName: names[item.veteranId] ?? "",
                isReviewed: item.isReviewed,
                date: DisplayDate.text(fromMilliseconds: item.createdAt),
                reply: item.reply
            )
        })
    }
}
