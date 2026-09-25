import Combine
import Foundation

protocol FavoritesRemoteDataSource: AnyObject {
    func favoritesPublisher(uid: String) -> AnyPublisher<Set<String>, Error>
    func set(uid: String, veteranId: String, isFavorite: Bool) async throws
    func addAll(uid: String, veteranIds: Set<String>) async throws
}
