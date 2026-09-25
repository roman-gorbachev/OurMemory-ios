import Foundation

enum Coordinates {
    private static let format = "%.6f"
    private static let maxLatitude = 90.0
    private static let maxLongitude = 180.0

    static func text(_ value: Double) -> String {
        return String(format: format, locale: Locale(identifier: "en_US_POSIX"), value)
    }

    static func latitude(from text: String) -> Double? {
        return number(from: text).flatMap { return (-maxLatitude...maxLatitude).contains($0) ? $0 : nil }
    }

    static func longitude(from text: String) -> Double? {
        return number(from: text).flatMap { return (-maxLongitude...maxLongitude).contains($0) ? $0 : nil }
    }

    private static func number(from text: String) -> Double? {
        return Double(text.replacingOccurrences(of: ",", with: ".").trimmed)
    }
}
