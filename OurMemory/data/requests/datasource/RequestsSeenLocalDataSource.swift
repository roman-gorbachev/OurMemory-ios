import Combine
import Foundation

final class RequestsSeenLocalDataSource {
    private static let seenAtKey = "requests_seen_at"

    private let preferences: PreferencesStore

    init(preferences: PreferencesStore) {
        self.preferences = preferences
    }

    func seenAtPublisher() -> AnyPublisher<Int64, Never> {
        return preferences.publisher { return ($0.object(forKey: Self.seenAtKey) as? NSNumber)?.int64Value ?? 0 }
    }

    func saveSeenAt(_ timestamp: Int64) {
        preferences.edit { $0.set(NSNumber(value: timestamp), forKey: Self.seenAtKey) }
    }
}
