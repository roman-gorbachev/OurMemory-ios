import Foundation

@Observable
final class VeteranEditorViewModel {
    private static let mediaFolder = "veterans"

    private(set) var veteranEditorUiState = VeteranEditorUiState.loading

    @ObservationIgnored private let veteranId: String
    @ObservationIgnored private let veteransRepository: VeteransRepository
    @ObservationIgnored private let burialsRepository: BurialsRepository
    @ObservationIgnored private let contentEditorRepository: ContentEditorRepository
    @ObservationIgnored private let mediaRepository: MediaRepository
    @ObservationIgnored private let currentUid: String
    @ObservationIgnored private var form: VeteranForm?
    @ObservationIgnored private var burials: [BurialUi] = []
    @ObservationIgnored private var status = EditorStatus()

    init(
        veteranId: String,
        veteransRepository: VeteransRepository,
        burialsRepository: BurialsRepository,
        contentEditorRepository: ContentEditorRepository,
        mediaRepository: MediaRepository,
        currentUid: String
    ) {
        self.veteranId = veteranId
        self.veteransRepository = veteransRepository
        self.burialsRepository = burialsRepository
        self.contentEditorRepository = contentEditorRepository
        self.mediaRepository = mediaRepository
        self.currentUid = currentUid
    }

    private var isNew: Bool {
        return veteranId.isEmpty
    }

    func load() async {
        guard form == nil else {
            return
        }
        do {
            if isNew {
                veteransRepository.invalidate()
            }
            let veterans = try await veteransRepository.allVeterans()
            burials = ((try? await burialsRepository.allBurials()) ?? []).map { return $0.toUiModel() }
            if isNew {
                form = VeteranForm(id: VeteranForm.nextId(after: veterans))
            } else if let veteran = veterans.first(where: { return $0.id == veteranId }) {
                form = VeteranForm(veteran: veteran)
            } else {
                veteranEditorUiState = .error
                return
            }
            rebuild()
        } catch {
            veteranEditorUiState = .error
        }
    }

    func onAction(_ action: VeteranEditorUserAction) {
        switch action {
        case .nameChanged(let value):
            update { $0.name = value }
        case .yearsChanged(let value):
            update { $0.years = value }
        case .categoryChanged(let value):
            update { $0.category = value }
        case .baseInfoChanged(let value):
            update { $0.baseInfo = value }
        case .allInfoChanged(let value):
            update { $0.allInfo = value }
        case .rewardCountChanged(let reward, let delta):
            update { form in
                let count = max((form.rewards[reward] ?? 0) + delta, 0)
                form.rewards[reward] = count == 0 ? nil : count
            }
        case .birthDateChanged(let value):
            update { $0.birthDate = value }
        case .deathDateChanged(let value):
            update { $0.deathDate = value }
        case .burialChanged(let value):
            update { $0.burialId = value }
        case .portraitPicked(let data):
            upload({ try await $0.uploadPhoto(data, folder: $1) }) { $0.portrait = $1 }
        case .audioPicked(let url):
            upload({ try await $0.uploadAudio(fileURL: url, folder: $1) }) { $0.audioUrl = $1 }
        case .audioRemoved:
            update { $0.audioUrl = "" }
        case .paragraphAdded:
            update { $0.entries.append(InfoEntry(id: UUID(), kind: .paragraph(text: ""))) }
        case .mediaPicked(let data):
            upload({ try await $0.uploadPhoto(data, folder: $1) }) { form, url in
                form.entries.append(InfoEntry(id: UUID(), kind: .media(url: url, caption: "")))
            }
        case .entryChanged(let entry):
            update { form in
                if let index = form.entries.firstIndex(where: { return $0.id == entry.id }) {
                    form.entries[index] = entry
                }
            }
        case .entryMoved(let id, let offset):
            update { form in
                if let index = form.entries.firstIndex(where: { return $0.id == id }) {
                    form.entries = form.entries.moved(index: index, offset: offset)
                }
            }
        case .entryRemoved(let id):
            update { $0.entries.removeAll { return $0.id == id } }
        case .failureDismissed:
            status.failure = nil
            rebuild()
        case .save:
            guard let form, form.isValid else {
                return
            }
            runWrite { [contentEditorRepository] in try await contentEditorRepository.saveVeteran(form.toVeteran()) }
        case .delete:
            guard !isNew else {
                return
            }
            runWrite { [contentEditorRepository, veteranId] in try await contentEditorRepository.deleteVeteran(veteranId: veteranId) }
        }
    }

    private func update(_ transform: (inout VeteranForm) -> Void) {
        guard var current = form else {
            return
        }
        transform(&current)
        form = current
        rebuild()
    }

    private func upload(
        _ request: @escaping (MediaRepository, String) async throws -> String,
        apply: @escaping (inout VeteranForm, String) -> Void
    ) {
        guard let form else {
            return
        }
        status.uploads += 1
        status.failure = nil
        rebuild()
        let folder = "\(Self.mediaFolder)/\(form.id)"
        Task {
            do {
                let url = try await request(mediaRepository, folder)
                update { apply(&$0, url) }
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
        veteranEditorUiState = .editing(data: VeteranEditorUiData(form: form, burials: burials, isNew: isNew, status: status, currentUid: currentUid))
    }
}
