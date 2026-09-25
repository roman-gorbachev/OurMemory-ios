import Foundation

enum TourProgress {
    static func resumeStopIndex(stopCount: Int, visitedStops: Set<Int>) -> Int? {
        guard !visitedStops.isEmpty else {
            return nil
        }
        return (0..<stopCount).first { return !visitedStops.contains($0) }
    }
}
