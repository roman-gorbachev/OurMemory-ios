import Foundation

nonisolated final class ProfanityDetector: Sendable {
    private static let minJoinedLength = 3
    private static let cyrillicLetters = "абвгдежзийклмнопрстуфхцчшщъыьэюя"
    private static let repeatedLetters = try? NSRegularExpression(pattern: "(\\p{L})\\1+")
    private static let nonLetters = try? NSRegularExpression(pattern: "[^\\p{L}]+")
    private static let lookalikes: [Character: Character] = [
        "a": "а", "o": "о", "e": "е", "p": "р", "c": "с", "x": "х", "y": "у",
        "k": "к", "m": "м", "b": "в", "h": "н", "t": "т", "u": "и", "n": "п",
        "r": "г", "i": "и", "і": "и", "ё": "е",
        "3": "з", "0": "о", "6": "б", "4": "ч"
    ]
    private static let lookalikeVariants: [[Character: Character]] = [
        lookalikes,
        lookalikes.merging(["u": "у"]) { _, new in return new }
    ]
    private static let safeFragments = [
        "страху", "хлеб", "хулиган", "команд", "мандарин", "мандат", "греб", "колеб", "небан", "небал", "ребал"
    ]
    private static let infixRoots = [
        "хуй", "хуе", "хуя", "хуи", "пизд", "пезд", "бляд", "ебан", "ебал", "ебат", "ебац", "ебуч",
        "ебну", "еблан", "ебло", "заеб", "наеб", "выеб", "уеб", "поеб", "съеб", "сьеб", "залуп",
        "мудак", "мудил", "мудозвон", "гандон", "пидор", "пидар", "пидр", "шлюх", "херн", "долбоеб",
        "ублюд"
    ]
    private static let prefixRoots = [
        "сука", "суки", "сукам", "сукин", "сучар", "сучий", "сучье", "падл", "шалав", "мразот"
    ]
    private static let exactWords: Set<String> = [
        "бля", "блять", "бляць", "сука", "суки", "сучка", "хули", "хер", "манда", "курва", "пох", "нах",
        "ебу", "еби", "ебет", "ебешь", "ебут", "ебись",
        "мразь", "мрази", "тварь", "твари", "чмо", "урод", "уроды", "уродина", "дебил", "дебилы",
        "выродок", "выродки", "гнида", "гниды"
    ]

    func containsProfanity(_ text: String) -> Bool {
        return ([text] + MaskedWords.expand(text, letters: Self.cyrillicLetters)).contains { candidate in
            return Self.lookalikeVariants.contains { lookalikes in
                return normalizedWords(candidate, lookalikes: lookalikes).contains(where: isProfane)
            }
        }
    }

    private func isProfane(_ word: String) -> Bool {
        let cleaned = Self.safeFragments.reduce(word) { current, safe in
            return current.replacingOccurrences(of: safe, with: "")
        }
        return Self.exactWords.contains(cleaned)
            || Self.prefixRoots.contains { return cleaned.hasPrefix($0) }
            || Self.infixRoots.contains { return cleaned.contains($0) }
    }

    private func normalizedWords(_ text: String, lookalikes: [Character: Character]) -> [String] {
        let mapped = String(text.lowercased().map { return lookalikes[$0] ?? $0 })
        let collapsed = Self.replace(Self.repeatedLetters, in: mapped, with: "$1")
        let separated = Self.replace(Self.nonLetters, in: collapsed, with: " ")
        let words = separated.split(separator: " ").map(String.init)
        return words + joinSingleLetters(words)
    }

    private func joinSingleLetters(_ words: [String]) -> [String] {
        var groups = [""]
        for word in words {
            if word.count == 1 {
                groups[groups.count - 1] += word
            } else {
                groups.append("")
            }
        }
        return groups.filter { return $0.count >= Self.minJoinedLength }
    }

    private static func replace(_ regex: NSRegularExpression?, in text: String, with template: String) -> String {
        guard let regex else {
            return text
        }
        let range = NSRange(text.startIndex..., in: text)
        return regex.stringByReplacingMatches(in: text, range: range, withTemplate: template)
    }
}
