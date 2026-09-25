import Foundation

@Observable
final class HomeViewModel {
    private(set) var homeUiState = HomeUiState.loading

    @ObservationIgnored private let repository: VeteransRepository
    @ObservationIgnored private let calendar: Calendar
    @ObservationIgnored private let now: () -> Date
    @ObservationIgnored private var veterans: [Veteran] = []
    @ObservationIgnored private var search = ""
    @ObservationIgnored private var checkedWar = true
    @ObservationIgnored private var checkedArt = true

    init(repository: VeteransRepository, calendar: Calendar, now: @escaping () -> Date) {
        self.repository = repository
        self.calendar = calendar
        self.now = now
    }

    func load() async {
        do {
            veterans = try await repository.allVeterans()
            rebuild()
        } catch {
            homeUiState = .error
        }
    }

    func onAction(_ action: HomeUserAction) {
        switch action {
        case .searchChanged(let text):
            search = text
        case .warToggled(let value):
            checkedWar = value
        case .artToggled(let value):
            checkedArt = value
        }
        rebuild()
    }

    private func rebuild() {
        let filtered = filteredVeterans()
        homeUiState = .success(data: HomeUiData(
            veterans: filtered.map { veteran in
                return VeteranItemUi(
                    id: veteran.id,
                    name: veteran.name,
                    years: veteran.years,
                    baseInfo: veteran.baseInfo,
                    portrait: veteran.portrait
                )
            },
            search: search,
            checkedWar: checkedWar,
            checkedArt: checkedArt,
            anniversaries: search.isBlank ? anniversaries() : []
        ))
    }

    private func filteredVeterans() -> [Veteran] {
        let matchesName: (Veteran) -> Bool = { [search] veteran in
            return search.isEmpty || veteran.name.localizedCaseInsensitiveContains(search)
        }
        switch (checkedWar, checkedArt) {
        case (true, true):
            return search.isBlank ? veterans : veterans.filter(matchesName)
        case (true, false):
            return veterans.filter { return $0.category == VeteranCategory.war.rawValue && matchesName($0) }
        case (false, true):
            return veterans.filter { return $0.category == VeteranCategory.art.rawValue && matchesName($0) }
        case (false, false):
            return []
        }
    }

    private func anniversaries() -> [AnniversaryUi] {
        let today = now()
        return veterans.flatMap { veteran in
            return veteran.anniversaries(on: today, calendar: calendar).map { anniversary in
                return AnniversaryUi(
                    veteranId: veteran.id,
                    name: veteran.name,
                    portrait: veteran.portrait,
                    isBirthday: anniversary.kind == .birthday,
                    year: anniversary.year
                )
            }
        }
    }
}
