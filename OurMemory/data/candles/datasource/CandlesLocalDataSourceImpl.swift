import Combine
import Foundation

final class CandlesLocalDataSourceImpl: CandlesLocalDataSource {
    private static let lastLitKeyPrefix = "candle_lit_"

    private let preferences: PreferencesStore

    init(preferences: PreferencesStore) {
        self.preferences = preferences
    }

    func lastLitDatePublisher(veteranId: String) -> AnyPublisher<String?, Never> {
        let key = Self.lastLitKeyPrefix + veteranId
        return preferences.publisher { return $0.string(forKey: key) }
    }

    func lastLitDate(veteranId: String) -> String? {
        let key = Self.lastLitKeyPrefix + veteranId
        return preferences.read { return $0.string(forKey: key) }
    }

    func saveLastLitDate(veteranId: String, date: String) {
        let key = Self.lastLitKeyPrefix + veteranId
        preferences.edit { $0.set(date, forKey: key) }
    }
}
