import CoreGraphics
import Foundation

nonisolated enum ScaledSize {
    private static let minimumSide = 1

    static func fitting(width: Int, height: Int, maxSide: Int) -> (width: Int, height: Int) {
        let longestSide = max(width, height)
        guard longestSide > maxSide else {
            return (width, height)
        }
        let scale = Double(maxSide) / Double(longestSide)
        return (
            max(Int((Double(width) * scale).rounded()), minimumSide),
            max(Int((Double(height) * scale).rounded()), minimumSide)
        )
    }
}
