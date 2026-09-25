import Combine
import Foundation

protocol FavoritesLocalDataSource: AnyObject {
    func favoritesPublisher() -> AnyPublisher<Set<String>, Never>
    func favorites() -> Set<String>
    func set(veteranId: String, isFavorite: Bool)
}
