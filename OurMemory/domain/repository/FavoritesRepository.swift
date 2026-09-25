import Combine
import Foundation

protocol FavoritesRepository: AnyObject {
    func favoritesPublisher() -> AnyPublisher<Set<String>, Never>
    func toggle(veteranId: String) async throws
}
