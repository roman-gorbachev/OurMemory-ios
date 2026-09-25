import Foundation

enum DisplayDate {
    private static let pattern = "dd.MM.yyyy HH:mm"
    private static let millisecondsPerSecond = 1000.0

    static func text(fromMilliseconds milliseconds: Int64) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = pattern
        return formatter.string(from: Date(timeIntervalSince1970: Double(milliseconds) / millisecondsPerSecond))
    }
}
