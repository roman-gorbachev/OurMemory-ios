import Combine
import Foundation

@Observable
final class MapViewModel {
    private static let cemeteryZoom: Float = 16
    private static let focusedZoom: Float = 19

    private(set) var mapUiState = MapUiState.loading
    private(set) var initialCamera = MapCamera(
        latitude: CemeteryLocation.latitude,
        longitude: CemeteryLocation.longitude,
        zoom: MapViewModel.cemeteryZoom
    )

    @ObservationIgnored private let focusedBurialId: String?
    @ObservationIgnored private let burialsRepository: BurialsRepository
    @ObservationIgnored private let veteransRepository: VeteransRepository
    @ObservationIgnored private let toursRepository: ToursRepository
    @ObservationIgnored private let tourProgressRepository: TourProgressRepository
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    @ObservationIgnored private var burials: [Burial] = []
    @ObservationIgnored private var veteransByBurial: [String: [Veteran]] = [:]
    @ObservationIgnored private var tours: [TourSummaryUi] = []
    @ObservationIgnored private var progress: [String: Set<Int>] = [:]
    @ObservationIgnored private var resolvedPhotos: [String: String] = [:]
    @ObservationIgnored private var selectedBurialId: String?
    @ObservationIgnored private var selectedDetails: BurialDetailsUi?
    @ObservationIgnored private var checkedWar = true
    @ObservationIgnored private var checkedArt = true
    @ObservationIgnored private var isLoaded = false

    init(
        focusedBurialId: String?,
        burialsRepository: BurialsRepository,
        veteransRepository: VeteransRepository,
        toursRepository: ToursRepository,
        tourProgressRepository: TourProgressRepository
    ) {
        self.focusedBurialId = focusedBurialId
        self.burialsRepository = burialsRepository
        self.veteransRepository = veteransRepository
        self.toursRepository = toursRepository
        self.tourProgressRepository = tourProgressRepository
        selectedBurialId = focusedBurialId
        observeMapUiState()
    }

    func load() async {
        guard !isLoaded else {
            return
        }
        do {
            async let loadedBurials = burialsRepository.allBurials()
            async let loadedVeterans = veteransRepository.allVeterans()
            let loadedTours = (try? await toursRepository.allTours()) ?? []
            burials = try await loadedBurials.filter { return $0.latitude != 0 || $0.longitude != 0 }
            veteransByBurial = Dictionary(grouping: try await loadedVeterans.filter { return !$0.burialId.isBlank }) { return $0.burialId }
            tours = loadedTours
                .filter { return !$0.stops.isEmpty }
                .map { return TourSummaryUi(id: $0.id, title: $0.title, description: $0.description, stopsCount: $0.stops.count) }
            if let focused = burials.first(where: { return $0.id == focusedBurialId }) {
                initialCamera = MapCamera(latitude: focused.latitude, longitude: focused.longitude, zoom: Self.focusedZoom)
            }
            isLoaded = true
            await refreshSelection()
        } catch {
            mapUiState = .error
        }
    }

    func onAction(_ action: MapUserAction) {
        switch action {
        case .markerTapped(let id):
            selectedBurialId = id
            Task { await refreshSelection() }
        case .sheetDismissed:
            selectedBurialId = nil
            selectedDetails = nil
            rebuild()
        case .warToggled(let value):
            checkedWar = value
            rebuild()
        case .artToggled(let value):
            checkedArt = value
            rebuild()
        }
    }

    private func observeMapUiState() {
        tourProgressRepository.progressPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] progress in
                self?.progress = progress
                self?.rebuild()
            }
            .store(in: &cancellables)
    }

    private func refreshSelection() async {
        selectedDetails = await selectedBurialId.flatMap { id in
            return burials.first { return $0.id == id }
        }.asyncMap { burial in
            return await details(for: burial)
        }
        rebuild()
    }

    private func details(for burial: Burial) async -> BurialDetailsUi {
        let photo: String
        if let cached = resolvedPhotos[burial.photo] {
            photo = cached
        } else {
            photo = await veteransRepository.resolveDirectUrl(burial.photo)
            resolvedPhotos[burial.photo] = photo
        }
        return BurialDetailsUi(
            burial: burial.toUiModel(),
            type: BurialType(value: burial.type),
            photo: photo,
            description: burial.description,
            veterans: (veteransByBurial[burial.id] ?? []).map { veteran in
                return VeteranShortUi(id: veteran.id, name: veteran.name, years: veteran.years, portrait: veteran.portrait)
            }
        )
    }

    private func rebuild() {
        guard isLoaded else {
            return
        }
        var categories = Set<String>()
        if checkedWar {
            categories.insert(VeteranCategory.war.rawValue)
        }
        if checkedArt {
            categories.insert(VeteranCategory.art.rawValue)
        }
        let markers = burials
            .filter { burial in
                let veterans = veteransByBurial[burial.id] ?? []
                return veterans.isEmpty || veterans.contains { return categories.contains($0.category) }
            }
            .map { return MapMarker(id: $0.id, latitude: $0.latitude, longitude: $0.longitude) }
        mapUiState = .success(data: MapUiData(
            markers: markers,
            selectedBurial: selectedDetails,
            checkedWar: checkedWar,
            checkedArt: checkedArt,
            tours: tours.map { tour in
                var summary = tour
                summary.visitedCount = (progress[tour.id] ?? []).filter { return $0 < tour.stopsCount }.count
                return summary
            }
        ))
    }
}

private extension Optional {
    func asyncMap<Result>(_ transform: (Wrapped) async -> Result) async -> Result? {
        guard let value = self else {
            return nil
        }
        return await transform(value)
    }
}
