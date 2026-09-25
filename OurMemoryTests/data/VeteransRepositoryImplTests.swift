import XCTest
@testable import OurMemory

final class VeteransRepositoryImplTests: XCTestCase {
    func testVeteransAreLoadedOnceAndServedFromCache() async throws {
        let dataSource = CountingVeteransDataSource()
        let repository = VeteransRepositoryImpl(dataSource: dataSource, yandexDisk: FailingYandexDisk(), contentLanguage: { return nil })
        _ = try await repository.allVeterans()
        _ = try await repository.allVeterans()
        XCTAssertEqual(dataSource.calls, 1)
    }

    func testInvalidateReloads() async throws {
        let dataSource = CountingVeteransDataSource()
        let repository = VeteransRepositoryImpl(dataSource: dataSource, yandexDisk: FailingYandexDisk(), contentLanguage: { return nil })
        _ = try await repository.allVeterans()
        repository.invalidate()
        _ = try await repository.allVeterans()
        XCTAssertEqual(dataSource.calls, 2)
    }

    func testYandexLinkFallsBackToOriginalUrlWhenResolvingFails() async {
        let repository = VeteransRepositoryImpl(dataSource: CountingVeteransDataSource(), yandexDisk: FailingYandexDisk(), contentLanguage: { return nil })
        let link = "https://disk.yandex.ru/i/photo"
        let resolved = await repository.resolveDirectUrl(link)
        XCTAssertEqual(resolved, link)
    }
}

private final class CountingVeteransDataSource: VeteransDataSource {
    private(set) var calls = 0

    func allVeterans() async throws -> [Veteran] {
        calls += 1
        return [Veteran(id: "1")]
    }
}

private final class FailingYandexDisk: YandexDiskDataSource {
    func downloadLink(publicKey: String) async throws -> YandexImage {
        throw URLError(.notConnectedToInternet)
    }
}
