import Foundation

nonisolated struct Anniversary: Hashable, Sendable {
    let kind: AnniversaryKind
    let year: Int
}
