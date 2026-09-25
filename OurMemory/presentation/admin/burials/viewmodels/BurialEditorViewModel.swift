import Foundation

@Observable
final class BurialEditorViewModel {
    private static let mediaFolder = "burials"

    private(set) var burialEditorUiState = BurialEditorUiState.loading

    @ObservationIgnored private let burialId: String
    @ObservationIgnored private let burialsRepository: BurialsRepository
    @ObservationIgnored private let contentEditorRepository: ContentEditorRepository
    @ObservationIgnored private let mediaRepository: MediaRepository
    @ObservationIgnored private let currentUid: String
    @ObservationIgnored private var form: BurialForm?
    @ObservationIgnored private var status = EditorStatus()

    init(
        burialId: String,
        burialsRepository: BurialsRepository,
        contentEditorRepository: ContentEditorRepository,
        mediaRepository: MediaRepository,
        currentUid: String
    ) {
        self.burialId = burialId
        self.burialsRepository = burialsRepository
        self.contentEditorRepository = contentEditorRepository
        self.mediaRepository = mediaRepository
        self.currentUid = currentUid
    }

    private var isNew: Bool {
        return burialId.isEmpty
    }

    func load() async {
        guard form == nil else {
            return
        }
        if isNew {
            form = BurialForm(
                id: contentEditorRepository.newBurialId(),
                latitude: CemeteryLocation.latitude,
                longitude: CemeteryLocation.longitude
            )
            rebuild()
            return
        }
        guard let burial = try? await burialsRepository.originalBurials().first(where: { return $0.id == burialId }) else {
            burialEditorUiState = .error
            return
        }
        form = BurialForm(burial: burial)
        rebuild()
    }

    func onAction(_ action: BurialEditorUserAction) {
        switch action {
        case .typeChanged(let value):
            update { $0.type = value }
        case .sectionChanged(let value):
            update { $0.section = value }
        case .rowChanged(let value):
            update { $0.row = value }
        case .placeChanged(let value):
            update { $0.place = value }
        case .descriptionChanged(let value):
            update { $0.description = value }
        case .latitudeChanged(let value):
            update { $0.latitude = value }
        case .longitudeChanged(let value):
            update { $0.longitude = value }
        case .pointPicked(let latitude, let longitude):
            update { form in
                form.latitude = Coordinates.text(latitude)
                form.longitude = Coordinates.text(longitude)
            }
        case .photoPicked(let data):
            uploadPhoto(data)
        case .photoRemoved:
            update { $0.photo = "" }
        case .failureDismissed:
            status.failure = nil
            rebuild()
        case .save:
            save()
        }
    }

    private func update(_ transform: (inout BurialForm) -> Void) {
        guard var current = form else {
            return
        }
        transform(&current)
        form = current
        rebuild()
    }

    private func uploadPhoto(_ data: Data) {
        guard let form, !status.isUploading else {
            return
        }
        status.uploads += 1
        status.failure = nil
        rebuild()
        let folder = "\(Self.mediaFolder)/\(form.id)"
        Task {
            do {
                let url = try await mediaRepository.uploadPhoto(data, folder: folder)
                update { $0.photo = url }
            } catch {
                status.failure = EditorFailure(uploadError: error)
            }
            status.uploads -= 1
            rebuild()
        }
    }

    private func save() {
        guard let form, form.isValid, !status.isBusy else {
            return
        }
        status.isSaving = true
        status.failure = nil
        rebuild()
        Task {
            do {
                try await contentEditorRepository.saveBurial(form.toBurial())
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
        burialEditorUiState = .editing(data: BurialEditorUiData(form: form, isNew: isNew, status: status, currentUid: currentUid))
    }
}
