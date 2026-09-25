import FirebaseDatabase
import Foundation

final class ToursDataSourceImpl: ToursDataSource {
    private let root: DatabaseReference

    init(root: DatabaseReference) {
        self.root = root
    }

    func allTours() async throws -> [Tour] {
        let snapshot = try await root.child(DatabaseNodes.tours).getData()
        return snapshot.childrenAs(Tour.self)
    }
}
