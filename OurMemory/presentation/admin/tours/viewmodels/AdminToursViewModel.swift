import Foundation

@Observable
final class AdminToursViewModel {
    private(set) var adminToursUiState = AdminToursUiState.loading

    @ObservationIgnored private let toursRepository: ToursRepository

    init(toursRepository: ToursRepository) {
        self.toursRepository = toursRepository
    }

    func load() async {
        do {
            adminToursUiState = .success(data: try await toursRepository.allTours()
                .sorted { return $0.title.localizedStandardCompare($1.title) == .orderedAscending }
                .map { return AdminTourItemUi(id: $0.id, title: $0.title, stopCount: $0.stops.count) })
        } catch {
            adminToursUiState = .error
        }
    }
}
