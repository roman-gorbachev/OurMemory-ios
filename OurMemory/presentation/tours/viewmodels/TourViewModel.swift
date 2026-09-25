import Combine
import Foundation

@Observable
final class TourViewModel {
    private static let namesSeparator = ", "

    private(set) var tourUiState = TourUiState.loading
    private(set) var playbackState = AudioPlaybackState()

    @ObservationIgnored private let tourId: String
    @ObservationIgnored private let toursRepository: ToursRepository
    @ObservationIgnored private let burialsRepository: BurialsRepository
    @ObservationIgnored private let veteransRepository: VeteransRepository
    @ObservationIgnored private let audioRepository: AudioRepository
    @ObservationIgnored private let tourProgressRepository: TourProgressRepository
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    @ObservationIgnored private var loadedTour: (title: String, description: String, stops: [TourStopUi])?
    @ObservationIgnored private var selectedStopIndex: Int?
    @ObservationIgnored private var visitedStops = Set<Int>()

    init(
        tourId: String,
        toursRepository: ToursRepository,
        burialsRepository: BurialsRepository,
        veteransRepository: VeteransRepository,
        audioRepository: AudioRepository,
        tourProgressRepository: TourProgressRepository
    ) {
        self.tourId = tourId
        self.toursRepository = toursRepository
        self.burialsRepository = burialsRepository
        self.veteransRepository = veteransRepository
        self.audioRepository = audioRepository
        self.tourProgressRepository = tourProgressRepository
        observeTourUiState()
    }

    deinit {
        let repository = audioRepository
        Task { @MainActor in
            repository.release()
        }
    }

    func load() async {
        guard loadedTour == nil else {
            return
        }
        do {
            async let tours = toursRepository.allTours()
            async let burials = burialsRepository.allBurials()
            async let veterans = veteransRepository.allVeterans()
            guard let tour = try await tours.first(where: { return $0.id == tourId }) else {
                tourUiState = .error
                return
            }
            let burialsById = Dictionary(try await burials.map { return ($0.id, $0) }) { first, _ in return first }
            let veteransByBurial = Dictionary(grouping: try await veterans.filter { return !$0.burialId.isBlank }) { return $0.burialId }
            let stops = tour.stops
                .compactMap { stop -> (TourStop, Burial)? in
                    guard let burial = burialsById[stop.burialId], burial.latitude != 0 || burial.longitude != 0 else {
                        return nil
                    }
                    return (stop, burial)
                }
                .enumerated()
                .map { index, pair in
                    let (stop, burial) = pair
                    let title = (veteransByBurial[burial.id] ?? []).map(\.name).joined(separator: Self.namesSeparator)
                    return TourStopUi(
                        number: index + 1,
                        title: title,
                        type: BurialType(value: burial.type),
                        burial: burial.toUiModel(),
                        text: stop.text,
                        audio: audio(for: stop, index: index, title: title, tourTitle: tour.title)
                    )
                }
            loadedTour = (tour.title, tour.description, stops)
            rebuild()
        } catch {
            tourUiState = .error
        }
    }

    func onAction(_ action: TourUserAction) {
        switch action {
        case .stopTapped(let index):
            selectedStopIndex = index
            rebuild()
        case .stopAudioTapped(let index):
            toggleAudio(at: index)
        case .stopVisitedToggled(let index):
            tourProgressRepository.toggleStop(tourId: tourId, stopIndex: index)
        case .resetProgress:
            tourProgressRepository.reset(tourId: tourId)
        }
    }

    private func observeTourUiState() {
        audioRepository.playbackStatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.playbackState = $0 }
            .store(in: &cancellables)
        tourProgressRepository.progressPublisher()
            .map { [tourId] in return $0[tourId] ?? [] }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] visited in
                self?.visitedStops = visited
                self?.rebuild()
            }
            .store(in: &cancellables)
    }

    private func rebuild() {
        guard let loadedTour else {
            return
        }
        tourUiState = .success(data: TourUiData(
            title: loadedTour.title,
            description: loadedTour.description,
            stops: loadedTour.stops,
            selectedStopIndex: selectedStopIndex
                ?? TourProgress.resumeStopIndex(stopCount: loadedTour.stops.count, visitedStops: visitedStops),
            visitedStops: visitedStops
        ))
    }

    private func audio(for stop: TourStop, index: Int, title: String, tourTitle: String) -> AudioItem? {
        guard !stop.audioUrl.isBlank, let url = URL(string: stop.audioUrl) else {
            return nil
        }
        return AudioItem(id: "\(tourId)_\(index)", url: url, title: title.isBlank ? tourTitle : title, subtitle: tourTitle)
    }

    private func toggleAudio(at index: Int) {
        guard let stops = loadedTour?.stops, stops.indices.contains(index), let audio = stops[index].audio else {
            return
        }
        if playbackState.currentAudio?.id != audio.id {
            audioRepository.play(audio)
        } else if playbackState.isPlaying {
            audioRepository.pause()
        } else {
            audioRepository.resume()
        }
    }
}
