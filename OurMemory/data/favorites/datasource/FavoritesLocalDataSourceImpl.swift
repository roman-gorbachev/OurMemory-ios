import Combine
import Foundation

final class FavoritesLocalDataSourceImpl: FavoritesLocalDataSource {
    private static let favoritesKey = "favorite_veterans"

    private let preferences: PreferencesStore

    init(preferences: PreferencesStore) {
        self.preferences = preferences
    }

    func favoritesPublisher() -> AnyPublisher<Set<String>, Never> {
        return preferences.publisher { return Set($0.stringArray(forKey: Self.favoritesKey) ?? []) }
    }

    func favorites() -> Set<String> {
        return preferences.read { return Set($0.stringArray(forKey: Self.favoritesKey) ?? []) }
    }

    func set(veteranId: String, isFavorite: Bool) {
        preferences.edit { defaults in
            var favorites = Set(defaults.stringArray(forKey: Self.favoritesKey) ?? [])
            if isFavorite {
                favorites.insert(veteranId)
            } else {
                favorites.remove(veteranId)
            }
            defaults.set(favorites.sorted(), forKey: Self.favoritesKey)
        }
    }
}
