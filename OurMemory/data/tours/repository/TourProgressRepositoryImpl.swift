import Combine
import Foundation

final class TourProgressRepositoryImpl: TourProgressRepository {
    private static let keyPrefix = "tour_progress_"

    private let preferences: PreferencesStore

    init(preferences: PreferencesStore) {
        self.preferences = preferences
    }

    func progressPublisher() -> AnyPublisher<[String: Set<Int>], Never> {
        return preferences.publisher { defaults in
            var progress: [String: Set<Int>] = [:]
            for (key, value) in defaults.dictionaryRepresentation() where key.hasPrefix(Self.keyPrefix) {
                let stops = (value as? [String] ?? []).compactMap { return Int($0) }
                progress[String(key.dropFirst(Self.keyPrefix.count))] = Set(stops)
            }
            return progress
        }
    }

    func toggleStop(tourId: String, stopIndex: Int) {
        let key = Self.keyPrefix + tourId
        let stop = String(stopIndex)
        preferences.edit { defaults in
            var visited = Set(defaults.stringArray(forKey: key) ?? [])
            if visited.contains(stop) {
                visited.remove(stop)
            } else {
                visited.insert(stop)
            }
            defaults.set(visited.sorted(), forKey: key)
        }
    }

    func reset(tourId: String) {
        preferences.edit { defaults in
            defaults.removeObject(forKey: Self.keyPrefix + tourId)
        }
    }
}
