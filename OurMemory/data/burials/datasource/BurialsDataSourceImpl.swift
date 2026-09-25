import FirebaseDatabase
import Foundation

final class BurialsDataSourceImpl: BurialsDataSource {
    private let root: DatabaseReference

    init(root: DatabaseReference) {
        self.root = root
    }

    func allBurials() async throws -> [Burial] {
        let snapshot = try await root.child(DatabaseNodes.burials).getData()
        return snapshot.childrenAs(Burial.self)
    }
}
