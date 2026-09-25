import Foundation

@Observable
final class TourEditorViewModel {
    private static let mediaFolder = "tours"
    private static let namesSeparator = ", "

    private(set) var tourEditorUiState = TourEditorUiState.loading

    @ObservationIgnored private let tourId: String
    @ObservationIgnored private let toursRepository: ToursRepository
    @ObservationIgnored private let burialsRepository: BurialsRepository
    @ObservationIgnored private let veteransRepository: VeteransRepository
    @ObservationIgnored private let contentEditorRepository: ContentEditorRepository
    @ObservationIgnored private let mediaRepository: MediaRepository
    @ObservationIgnored private let currentUid: String
    @ObservationIgnored private var form: TourForm?
    @ObservationIgnored private var burials: [AdminBurialItemUi] = []
    @ObservationIgnored private var status = EditorStatus()

    init(
        tourId: String,
        toursRepository: ToursRepository,
        burialsRepository: BurialsRepository,
        veteransRepository: VeteransRepository,
        contentEditorRepository: ContentEditorRepository,
        mediaRepository: MediaRepository,
        currentUid: String
    ) {
        self.tourId = tourId
        self.toursRepository = toursRepository
        self.burialsRepository = burialsRepository
        self.veteransRepository = veteransRepository
        self.contentEditorRepository = contentEditorRepository
        self.mediaRepository = mediaRepository
        self.currentUid = currentUid
    }

    private var isNew: Bool {
        return tourId.isEmpty
    }

    func load() async {
        guard form == nil else {
            return
        }
        do {
            let veterans = (try? await veteransRepository.allVeterans()) ?? []
            let namesByBurial = Dictionary(grouping: veterans.filter { return !$0.burialId.isBlank }) { return $0.burialId }
            burials = try await burialsRepository.allBurials().map { burial in
                return AdminBurialItemUi(
                    burial: burial.toUiModel(),
                    type: BurialType(value: burial.type),
                    veteranNames: (namesByBurial[burial.id] ?? []).map(\.name).joined(separator: Self.namesSeparator)
                )
            }
            if isNew {
                form = TourForm(id: contentEditorRepository.newTourId())
            } else if let tour = try await toursRepository.allTours().first(where: { return $0.id == tourId }) {
                form = TourForm(tour: tour)
            } else {
                tourEditorUiState = .error
                return
            }
            rebuild()
        } catch {
            tourEditorUiState = .error
        }
    }

    func onAction(_ action: TourEditorUserAction) {
        switch action {
        case .titleChanged(let value):
            update { $0.title = value }
        case .descriptionChanged(let value):
            update { $0.description = value }
        case .stopAdded(let burialId):
            update { $0.stops.append(TourStopForm(burialId: burialId)) }
        case .stopTextChanged(let id, let text):
            updateStop(id) { $0.text = text }
        case .stopAudioPicked(let id, let url):
            uploadAudio(for: id, fileURL: url)
        case .stopAudioRemoved(let id):
            updateStop(id) { $0.audioUrl = "" }
        case .stopsMoved(let offsets, let destination):
            update { $0.stops.move(fromOffsets: offsets, toOffset: destination) }
        case .stopsRemoved(let offsets):
            update { $0.stops.remove(atOffsets: offsets) }
        case .failureDismissed:
            status.failure = nil
            rebuild()
        case .save:
            guard let form, form.isValid else {
                return
            }
            runWrite { [contentEditorRepository] in try await contentEditorRepository.saveTour(form.toTour()) }
        case .delete:
            guard !isNew else {
                return
            }
            runWrite { [contentEditorRepository, tourId] in try await contentEditorRepository.deleteTour(tourId: tourId) }
        }
    }

    private func update(_ transform: (inout TourForm) -> Void) {
        guard var current = form else {
            return
        }
        transform(&current)
        form = current
        rebuild()
    }

    private func updateStop(_ id: UUID, _ transform: (inout TourStopForm) -> Void) {
        update { form in
            if let index = form.stops.firstIndex(where: { return $0.id == id }) {
                transform(&form.stops[index])
            }
        }
    }

    private func uploadAudio(for stopId: UUID, fileURL: URL) {
        guard let form else {
            return
        }
        status.uploads += 1
        status.failure = nil
        rebuild()
        let folder = "\(Self.mediaFolder)/\(form.id)"
        Task {
            do {
                let url = try await mediaRepository.uploadAudio(fileURL: fileURL, folder: folder)
                updateStop(stopId) { $0.audioUrl = url }
            } catch {
                status.failure = EditorFailure(uploadError: error)
            }
            status.uploads -= 1
            rebuild()
        }
    }

    private func runWrite(_ write: @escaping () async throws -> Void) {
        guard !status.isBusy else {
            return
        }
        status.isSaving = true
        status.failure = nil
        rebuild()
        Task {
            do {
                try await write()
                status.isClosed = true
            } catch {
                status.failure = .save
            }
            status.isSaving = false
            rebuild()
        }
    }

    private func rebuild() {
        guard let form else {
            return
        }
        tourEditorUiState = .editing(data: TourEditorUiData(form: form, burials: burials, isNew: isNew, status: status, currentUid: currentUid))
    }
}
