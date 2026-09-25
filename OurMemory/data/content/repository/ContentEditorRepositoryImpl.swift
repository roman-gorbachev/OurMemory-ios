import Foundation

final class ContentEditorRepositoryImpl: ContentEditorRepository {
    private let dataSource: ContentDataSource
    private let veteransRepository: VeteransRepository
    private let burialsRepository: BurialsRepository
    private let toursRepository: ToursRepository

    init(
        dataSource: ContentDataSource,
        veteransRepository: VeteransRepository,
        burialsRepository: BurialsRepository,
        toursRepository: ToursRepository
    ) {
        self.dataSource = dataSource
        self.veteransRepository = veteransRepository
        self.burialsRepository = burialsRepository
        self.toursRepository = toursRepository
    }

    func saveVeteran(_ veteran: Veteran) async throws {
        try await dataSource.saveVeteran(veteran)
        veteransRepository.invalidate()
    }

    func deleteVeteran(veteranId: String) async throws {
        try await dataSource.deleteVeteran(veteranId: veteranId)
        veteransRepository.invalidate()
    }

    func newBurialId() -> String {
        return dataSource.newBurialId()
    }

    func saveBurial(_ burial: Burial) async throws {
        try await dataSource.saveBurial(burial)
        burialsRepository.invalidate()
    }

    func newTourId() -> String {
        return dataSource.newTourId()
    }

    func saveTour(_ tour: Tour) async throws {
        try await dataSource.saveTour(tour)
        toursRepository.invalidate()
    }

    func deleteTour(tourId: String) async throws {
        try await dataSource.deleteTour(tourId: tourId)
        toursRepository.invalidate()
    }
}
