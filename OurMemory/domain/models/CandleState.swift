import Foundation

nonisolated struct CandleState: Hashable, Sendable {
    var count: Int64 = 0
    var isLitToday = false
}
