import Foundation

extension Array {
    func moved(index: Int, offset: Int) -> [Element] {
        let target = index + offset
        guard indices.contains(index), indices.contains(target) else {
            return self
        }
        var result = self
        result.insert(result.remove(at: index), at: target)
        return result
    }
}
