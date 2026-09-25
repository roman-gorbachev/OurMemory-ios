import FirebaseDatabase

extension DataSnapshot {
    var childSnapshots: [DataSnapshot] {
        return children.allObjects.compactMap { return $0 as? DataSnapshot }
    }

    func childrenAs<T: Decodable>(_ type: T.Type) -> [T] {
        return childSnapshots.compactMap { child in
            return try? child.data(as: type)
        }
    }

    var childStrings: [String] {
        return childSnapshots.compactMap { return $0.value as? String }
    }
}
