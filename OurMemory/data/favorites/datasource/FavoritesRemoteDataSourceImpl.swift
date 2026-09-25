import Combine
import FirebaseDatabase
import Foundation

final class FavoritesRemoteDataSourceImpl: FavoritesRemoteDataSource {
    private let root: DatabaseReference

    init(root: DatabaseReference) {
        self.root = root
    }

    func favoritesPublisher(uid: String) -> AnyPublisher<Set<String>, Error> {
        return favorites(uid: uid)
            .valuePublisher()
            .map { snapshot in return Set(snapshot.childSnapshots.map { return $0.key }) }
            .eraseToAnyPublisher()
    }

    func set(uid: String, veteranId: String, isFavorite: Bool) async throws {
        let reference = favorites(uid: uid).child(veteranId)
        if isFavorite {
            try await reference.setValue(true)
        } else {
            try await reference.removeValue()
        }
    }

    func addAll(uid: String, veteranIds: Set<String>) async throws {
        guard !veteranIds.isEmpty else {
            return
        }
        let values = Dictionary(uniqueKeysWithValues: veteranIds.map { return ($0, true) })
        try await favorites(uid: uid).updateChildValues(values)
    }

    private func favorites(uid: String) -> DatabaseReference {
        return root.child(DatabaseNodes.users).child(uid).child(DatabaseNodes.favorites)
    }
}
