import Foundation

nonisolated final class LatinProfanityDetector: Sendable {
    private static let latinLetters = "abcdefghijklmnopqrstuvwxyz"
    private static let repeatedLetters = try? NSRegularExpression(pattern: "(\\p{L})\\1+")
    private static let nonLetters = try? NSRegularExpression(pattern: "[^\\p{L}]+")
    private static let lookalikes: [Character: Character] = [
        "а": "a", "о": "o", "е": "e", "р": "p", "с": "c", "х": "x", "у": "y",
        "к": "k", "м": "m", "т": "t", "і": "i",
        "0": "o", "1": "i", "3": "e", "4": "a", "5": "s", "!": "i", "$": "s"
    ]
    private static let infixRoots = [
        "fuck", "bitch", "whore", "nigger", "nigga", "asshole", "motherf", "bullshit",
        "pizd", "pezd", "blyad", "blyat", "bliat", "xuy", "xuj", "huyn", "nahuy", "nahui",
        "ebal", "eban", "ebat", "zaeb", "naeb", "pidor", "pidar", "mudak"
    ]
    private static let exactWords: Set<String> = [
        "shit", "shitty", "cunt", "cunts", "dick", "slut", "fag", "faggot", "fck", "fuk", "bastard",
        "huy", "huj", "blya", "suka", "suki"
    ]

    func containsProfanity(_ text: String) -> Bool {
        return ([text] + MaskedWords.expand(text, letters: Self.latinLetters)).contains { candidate in
            return normalizedWords(candidate).contains { word in
                return Self.exactWords.contains(word) || Self.infixRoots.contains { return word.contains($0) }
            }
        }
    }

    private func normalizedWords(_ text: String) -> [String] {
        let mapped = String(text.lowercased().map { return Self.lookalikes[$0] ?? $0 })
        let words = Self.replace(Self.nonLetters, in: mapped, with: " ").split(separator: " ").map(String.init)
        return words + words.map { return Self.replace(Self.repeatedLetters, in: $0, with: "$1") }
    }

    private static func replace(_ regex: NSRegularExpression?, in text: String, with template: String) -> String {
        guard let regex else {
            return text
        }
        let range = NSRange(text.startIndex..., in: text)
        return regex.stringByReplacingMatches(in: text, range: range, withTemplate: template)
    }
}
