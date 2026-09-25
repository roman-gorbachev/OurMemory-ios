import Foundation

final class VeteransRepositoryImpl: VeteransRepository {
    private static let yandexMarker = "yandex"

    private let yandexDisk: YandexDiskDataSource
    private let cache: CachedLoader<[Veteran]>

    init(dataSource: VeteransDataSource, yandexDisk: YandexDiskDataSource) {
        self.yandexDisk = yandexDisk
        cache = CachedLoader { return try await dataSource.allVeterans() }
    }

    func allVeterans() async throws -> [Veteran] {
        return try await cache.value()
    }

    func resolveDirectUrl(_ url: String) async -> String {
        guard url.contains(Self.yandexMarker) else {
            return url
        }
        guard let href = try? await yandexDisk.downloadLink(publicKey: url).href, !href.isEmpty else {
            return url
        }
        return href
    }

    func invalidate() {
        cache.invalidate()
    }
}
