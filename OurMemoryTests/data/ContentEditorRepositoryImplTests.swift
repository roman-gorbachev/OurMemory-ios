import XCTest
@testable import OurMemory

final class ContentEditorRepositoryImplTests: XCTestCase {
    func testEachWriteRefreshesOnlyItsOwnCache() async throws {
        let dataSource = FakeContentDataSource()
        let veterans = FakeVeteransRepository()
        let burials = FakeBurialsRepository()
        let tours = FakeToursRepository()
        let repository = ContentEditorRepositoryImpl(
            dataSource: dataSource,
            veteransRepository: veterans,
            burialsRepository: burials,
            toursRepository: tours
        )
        try await repository.saveVeteran(Veteran(id: "1"))
        try await repository.deleteVeteran(veteranId: "1")
        try await repository.saveBurial(Burial(id: "b_001"))
        try await repository.saveTour(Tour(id: "t_1"))
        try await repository.deleteTour(tourId: "t_1")
        XCTAssertEqual(dataSource.writes.count, 5)
        XCTAssertEqual(veterans.invalidations, 2)
        XCTAssertEqual(burials.invalidations, 1)
        XCTAssertEqual(tours.invalidations, 2)
    }
}
