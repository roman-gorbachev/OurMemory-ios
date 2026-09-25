import Foundation

nonisolated final class ExtremismDetector: Sendable {
    private static let separators = try? NSRegularExpression(pattern: "[^\\p{L}\\p{N}]+")
    private static let numericCodes = try? NSRegularExpression(pattern: "(?<!\\d)14\\s*[/\\\\-]?\\s*88(?!\\d)")
    private static let symbols = ["卐", "卍", "ϟϟ", "ᛋᛋ", "ᛊᛊ"]
    private static let phrases = [
        "хайль", "зиг хайль", "хайль гитлер", "слава гитлеру", "гитлер прав", "гитлер был прав",
        "зига", "зигу", "зиговать", "зигует", "зигуют",
        "heil", "sieg heil", "heil hitler", "white power", "white pride"
    ]

    func containsExtremism(_ text: String) -> Bool {
        let lowered = text.lowercased().replacingOccurrences(of: "ё", with: "е")
        let words = Self.replace(Self.separators, in: lowered, with: " ").split(separator: " ").map(String.init)
        let normalized = " \(words.joined(separator: " ")) "
        return Self.symbols.contains { return text.contains($0) }
            || Self.matches(Self.numericCodes, in: text)
            || Self.phrases.contains { return normalized.contains(" \($0) ") }
    }

    private static func matches(_ regex: NSRegularExpression?, in text: String) -> Bool {
        guard let regex else {
            return false
        }
        return regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)) != nil
    }

    private static func replace(_ regex: NSRegularExpression?, in text: String, with template: String) -> String {
        guard let regex else {
            return text
        }
        return regex.stringByReplacingMatches(in: text, range: NSRange(text.startIndex..., in: text), withTemplate: template)
    }
}
