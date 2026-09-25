import Combine
import Foundation

@Observable
final class MyRequestsViewModel {
    private(set) var myRequestsUiState = MyRequestsUiState.loading

    @ObservationIgnored private let myRequestsRepository: MyRequestsRepository
    @ObservationIgnored private let veteransRepository: VeteransRepository
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    @ObservationIgnored private var names: [String: String] = [:]
    @ObservationIgnored private var requests: [MyRequest]?

    init(myRequestsRepository: MyRequestsRepository, veteransRepository: VeteransRepository) {
        self.myRequestsRepository = myRequestsRepository
        self.veteransRepository = veteransRepository
        observeMyRequestsUiState()
    }

    func loadNames() async {
        let veterans = (try? await veteransRepository.allVeterans()) ?? []
        names = Dictionary(veterans.map { return ($0.id, $0.name) }) { first, _ in return first }
        rebuild()
    }

    func markAllSeen() {
        myRequestsRepository.markAllSeen()
    }

    private func observeMyRequestsUiState() {
        myRequestsRepository.myRequestsPublisher()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure = completion {
                        self?.myRequestsUiState = .error
                    }
                },
                receiveValue: { [weak self] requests in
                    self?.requests = requests
                    self?.rebuild()
                }
            )
            .store(in: &cancellables)
    }

    private func rebuild() {
        guard let requests else {
            return
        }
        myRequestsUiState = .success(data: requests.map { request in
            return MyRequestItemUi(
                requestId: request.id,
                kind: request.kind,
                veteranName: names[request.veteranId] ?? "",
                text: request.text,
                status: request.status,
                reply: request.reply,
                date: DisplayDate.text(fromMilliseconds: request.createdAt)
            )
        })
    }
}
