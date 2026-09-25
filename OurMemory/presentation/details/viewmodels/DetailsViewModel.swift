import Combine
import Foundation

@Observable
final class DetailsViewModel {
    private static let bundledBiographyVeteranId = "10"
    private static let bundledBiographyName = "veteran_bio_10"
    private static let bundledBiographyExtension = "mp3"

    private(set) var detailsUiState = DetailsUiState.loading
    private(set) var playbackState = AudioPlaybackState()
    private(set) var candleState = CandleState()
    private(set) var isFavorite = false
    private(set) var shouldAskNotifications = false

    @ObservationIgnored private let veteranId: String
    @ObservationIgnored private let veteransRepository: VeteransRepository
    @ObservationIgnored private let burialsRepository: BurialsRepository
    @ObservationIgnored private let audioRepository: AudioRepository
    @ObservationIgnored private let candlesRepository: CandlesRepository
    @ObservationIgnored private let settingsRepository: SettingsRepository
    @ObservationIgnored private let favoritesRepository: FavoritesRepository
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()

    init(
        veteranId: String,
        veteransRepository: VeteransRepository,
        burialsRepository: BurialsRepository,
        audioRepository: AudioRepository,
        candlesRepository: CandlesRepository,
        settingsRepository: SettingsRepository,
        favoritesRepository: FavoritesRepository
    ) {
        self.veteranId = veteranId
        self.veteransRepository = veteransRepository
        self.burialsRepository = burialsRepository
        self.audioRepository = audioRepository
        self.candlesRepository = candlesRepository
        self.settingsRepository = settingsRepository
        self.favoritesRepository = favoritesRepository
        observeDetailsUiState()
    }

    deinit {
        let repository = audioRepository
        Task { @MainActor in
            repository.release()
        }
    }

    func load() async {
        guard case .loading = detailsUiState else {
            return
        }
        do {
            async let veterans = veteransRepository.allVeterans()
            let burials = (try? await burialsRepository.allBurials()) ?? []
            guard let veteran = try await veterans.first(where: { return $0.id == veteranId }) else {
                detailsUiState = .error
                return
            }
            let links = veteran.veteransInfo.filter { return $0.contains(VeteranInfoFormat.linkMarker) }
            let paragraphs = veteran.veteransInfo.filter { return !$0.contains(VeteranInfoFormat.linkMarker) }
            detailsUiState = .success(data: DetailsUiData(
                veteranId: veteran.id,
                name: veteran.name,
                years: veteran.years,
                portrait: veteran.portrait,
                rewards: RewardsParser.parse(veteran.rewards),
                paragraphs: uniqueParagraphs([veteran.allInfo] + paragraphs),
                media: await resolveMedia(links),
                audio: audio(for: veteran),
                burial: veteran.burialId.isBlank ? nil : burials.first { return $0.id == veteran.burialId }?.toUiModel()
            ))
        } catch {
            detailsUiState = .error
        }
    }

    func onAction(_ action: DetailsUserAction) {
        switch action {
        case .audio(let audioAction):
            onAudioAction(audioAction)
        case .lightCandle:
            Task { try? await candlesRepository.lightCandle(veteranId: veteranId) }
        case .notificationsAsked:
            settingsRepository.markNotificationsAsked()
        case .toggleFavorite:
            Task { try? await favoritesRepository.toggle(veteranId: veteranId) }
        }
    }

    private func observeDetailsUiState() {
        audioRepository.playbackStatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.playbackState = $0 }
            .store(in: &cancellables)
        candlesRepository.candleStatePublisher(veteranId: veteranId)
            .replaceError(with: CandleState())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.candleState = $0 }
            .store(in: &cancellables)
        favoritesRepository.favoritesPublisher()
            .map { [veteranId] in return $0.contains(veteranId) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.isFavorite = $0 }
            .store(in: &cancellables)
        settingsRepository.notificationsAskedPublisher()
            .map { return !$0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.shouldAskNotifications = $0 }
            .store(in: &cancellables)
    }

    private func onAudioAction(_ action: AudioAction) {
        switch action {
        case .play:
            if case .success(let data) = detailsUiState, let audio = data.audio {
                audioRepository.play(audio)
            }
        case .pause:
            audioRepository.pause()
        case .resume:
            audioRepository.resume()
        case .stop:
            audioRepository.stop()
        case .seek(let seconds):
            audioRepository.seek(to: seconds)
        }
    }

    private func uniqueParagraphs(_ paragraphs: [String]) -> [String] {
        var seen = Set<String>()
        return paragraphs
            .map { return $0.trimmed }
            .filter { paragraph in
                return !paragraph.isEmpty && seen.insert(paragraph).inserted
            }
    }

    private func resolveMedia(_ links: [String]) async -> [MediaUi] {
        let repository = veteransRepository
        return await withTaskGroup(of: (Int, MediaUi).self) { group in
            for (index, link) in links.enumerated() {
                group.addTask {
                    let parts = link.split(separator: Character(VeteranInfoFormat.descriptionSeparator), maxSplits: 1, omittingEmptySubsequences: false)
                    let url = String(parts.first ?? "").trimmed
                    let description = parts.count > 1 ? String(parts[1]).trimmed : ""
                    return (index, MediaUi(url: await repository.resolveDirectUrl(url), description: description))
                }
            }
            var media = [MediaUi?](repeating: nil, count: links.count)
            for await (index, item) in group {
                media[index] = item
            }
            return media.compactMap { return $0 }
        }
    }

    private func audio(for veteran: Veteran) -> AudioItem? {
        if !veteran.audioUrl.isBlank, let url = URL(string: veteran.audioUrl) {
            return AudioItem(id: veteran.id, url: url, title: veteran.name)
        }
        if veteran.id == Self.bundledBiographyVeteranId,
           let url = Bundle.main.url(forResource: Self.bundledBiographyName, withExtension: Self.bundledBiographyExtension) {
            return AudioItem(id: veteran.id, url: url, title: veteran.name)
        }
        return nil
    }
}
