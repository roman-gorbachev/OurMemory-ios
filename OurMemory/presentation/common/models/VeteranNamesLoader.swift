import Foundation

enum VeteranNamesLoader {
    static func names(from repository: VeteransRepository) async -> [String: String] {
        let veterans = (try? await repository.allVeterans()) ?? []
        return Dictionary(veterans.map { return ($0.id, $0.name) }) { first, _ in return first }
    }
}
