import Foundation

nonisolated struct NsfwScores: Hashable, Sendable {
    private static let explicitThreshold: Float = 0.4
    private static let sexyThreshold: Float = 0.6
    private static let combinedThreshold: Float = 0.6

    var hentai: Float = 0
    var porn: Float = 0
    var sexy: Float = 0

    var isExplicit: Bool {
        return porn >= Self.explicitThreshold
            || hentai >= Self.explicitThreshold
            || sexy >= Self.sexyThreshold
            || porn + hentai + sexy >= Self.combinedThreshold
    }
}
