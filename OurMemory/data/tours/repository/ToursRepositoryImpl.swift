import Foundation

final class ToursRepositoryImpl: ToursRepository {
    private let cache: CachedLoader<[Tour]>

    init(dataSource: ToursDataSource) {
        cache = CachedLoader { return try await dataSource.allTours() }
    }

    func allTours() async throws -> [Tour] {
        return try await cache.value()
    }

    func invalidate() {
        cache.invalidate()
    }
}
