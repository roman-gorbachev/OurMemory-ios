import Foundation

@Observable
final class AdminVeteransViewModel {
    private(set) var adminVeteransUiState = AdminVeteransUiState.loading
    var search = "" {
        didSet {
            rebuild()
        }
    }

    @ObservationIgnored private let veteransRepository: VeteransRepository
    @ObservationIgnored private var veterans: [Veteran]?

    init(veteransRepository: VeteransRepository) {
        self.veteransRepository = veteransRepository
    }

    func load() async {
        do {
            veterans = try await veteransRepository.allVeterans()
            rebuild()
        } catch {
            adminVeteransUiState = .error
        }
    }

    private func rebuild() {
        guard let veterans else {
            return
        }
        let query = search.trimmed
        adminVeteransUiState = .success(data: veterans
            .filter { return query.isEmpty || $0.name.localizedCaseInsensitiveContains(query) }
            .sorted { return (Int($0.id) ?? Int.max) < (Int($1.id) ?? Int.max) }
            .map { return AdminVeteranItemUi(id: $0.id, name: $0.name, years: $0.years, portrait: $0.portrait) })
    }
}
