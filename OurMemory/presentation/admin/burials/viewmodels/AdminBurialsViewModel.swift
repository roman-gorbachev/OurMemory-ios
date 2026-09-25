import Foundation

@Observable
final class AdminBurialsViewModel {
    private static let namesSeparator = ", "

    private(set) var adminBurialsUiState = AdminBurialsUiState.loading

    @ObservationIgnored private let burialsRepository: BurialsRepository
    @ObservationIgnored private let veteransRepository: VeteransRepository

    init(burialsRepository: BurialsRepository, veteransRepository: VeteransRepository) {
        self.burialsRepository = burialsRepository
        self.veteransRepository = veteransRepository
    }

    func load() async {
        do {
            let veterans = (try? await veteransRepository.allVeterans()) ?? []
            let namesByBurial = Dictionary(grouping: veterans.filter { return !$0.burialId.isBlank }) { return $0.burialId }
            let burials = try await burialsRepository.allBurials()
            adminBurialsUiState = .success(data: burials
                .sorted(by: Self.plotOrder)
                .map { burial in
                    return AdminBurialItemUi(
                        burial: burial.toUiModel(),
                        type: BurialType(value: burial.type),
                        veteranNames: (namesByBurial[burial.id] ?? []).map(\.name).joined(separator: Self.namesSeparator)
                    )
                })
        } catch {
            adminBurialsUiState = .error
        }
    }

    private static func plotOrder(_ first: Burial, _ second: Burial) -> Bool {
        let firstKey = [Int(first.section), Int(first.row), Int(first.place)]
        let secondKey = [Int(second.section), Int(second.row), Int(second.place)]
        for (left, right) in zip(firstKey, secondKey) where left != right {
            guard let left else {
                return true
            }
            guard let right else {
                return false
            }
            return left < right
        }
        return false
    }
}
