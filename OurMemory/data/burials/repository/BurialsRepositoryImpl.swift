import Foundation

final class BurialsRepositoryImpl: BurialsRepository {
    private let contentLanguage: () -> String?
    private let cache: CachedLoader<[Burial]>

    init(dataSource: BurialsDataSource, contentLanguage: @escaping () -> String?) {
        self.contentLanguage = contentLanguage
        cache = CachedLoader { return try await dataSource.allBurials() }
    }

    func allBurials() async throws -> [Burial] {
        let languageKey = contentLanguage()
        return try await cache.value().map { return $0.localized(to: languageKey) }
    }

    func originalBurials() async throws -> [Burial] {
        return try await cache.value()
    }

    func invalidate() {
        cache.invalidate()
    }
}
