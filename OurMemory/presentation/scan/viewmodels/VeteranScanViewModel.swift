import Foundation

@Observable
final class VeteranScanViewModel {
    private(set) var veteranScanUiState = VeteranScanUiState.loading

    @ObservationIgnored private let repository: VeteransRepository
    @ObservationIgnored private var originalVeterans: [Veteran] = []
    @ObservationIgnored private var localizedVeterans: [String: Veteran] = [:]

    init(repository: VeteransRepository) {
        self.repository = repository
    }

    func load() async {
        do {
            originalVeterans = try await repository.originalVeterans()
            let veterans = try await repository.allVeterans()
            localizedVeterans = Dictionary(veterans.map { return ($0.id, $0) }, uniquingKeysWith: { first, _ in return first })
            veteranScanUiState = .success(data: VeteranScanUiData(candidates: [], hasRecognizedText: false))
        } catch {
            veteranScanUiState = .error
        }
    }

    func onAction(_ action: VeteranScanUserAction) {
        switch action {
        case .textRecognized(let text):
            showCandidates(for: text)
        }
    }

    private func showCandidates(for text: String) {
        guard case .success = veteranScanUiState else {
            return
        }
        let candidates = VeteranNameMatcher.candidates(in: text, among: originalVeterans).map { original in
            let veteran = localizedVeterans[original.id] ?? original
            return VeteranItemUi(
                id: veteran.id,
                name: veteran.name,
                years: veteran.years,
                baseInfo: veteran.baseInfo,
                portrait: veteran.portrait
            )
        }
        veteranScanUiState = .success(data: VeteranScanUiData(candidates: candidates, hasRecognizedText: !text.isBlank))
    }
}
