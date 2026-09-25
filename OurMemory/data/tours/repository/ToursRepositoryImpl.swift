import Foundation

final class ToursRepositoryImpl: ToursRepository {
    private let contentLanguage: () -> String?
    private let cache: CachedLoader<[Tour]>

    init(dataSource: ToursDataSource, contentLanguage: @escaping () -> String?) {
        self.contentLanguage = contentLanguage
        cache = CachedLoader { return try await dataSource.allTours() }
    }

    func allTours() async throws -> [Tour] {
        let languageKey = contentLanguage()
        return try await cache.value().map { return $0.localized(to: languageKey) }
    }

    func originalTours() async throws -> [Tour] {
        return try await cache.value()
    }

    func invalidate() {
        cache.invalidate()
    }
}
