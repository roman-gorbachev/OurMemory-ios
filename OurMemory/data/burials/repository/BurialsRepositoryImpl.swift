import Foundation

final class BurialsRepositoryImpl: BurialsRepository {
    private let cache: CachedLoader<[Burial]>

    init(dataSource: BurialsDataSource) {
        cache = CachedLoader { return try await dataSource.allBurials() }
    }

    func allBurials() async throws -> [Burial] {
        return try await cache.value()
    }

    func invalidate() {
        cache.invalidate()
    }
}
