import FirebaseDatabase
import Foundation

final class VeteransDataSourceImpl: VeteransDataSource {
    private let root: DatabaseReference

    init(root: DatabaseReference) {
        self.root = root
    }

    func allVeterans() async throws -> [Veteran] {
        let snapshot = try await root.child(DatabaseNodes.veterans).getData()
        return snapshot.childrenAs(Veteran.self)
    }
}
