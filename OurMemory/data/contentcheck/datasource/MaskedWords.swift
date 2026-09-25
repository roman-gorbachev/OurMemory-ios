import Foundation

nonisolated enum MaskedWords {
    private static let maxMaskRuns = 2
    private static let maskRun = try? NSRegularExpression(pattern: "[*#%$@_.\\-]+")
    private static let tokenSeparators = try? NSRegularExpression(pattern: "[\\s,!?;:()\"«»]+")
    private static let edgePunctuation: Set<Character> = [".", "-", "_"]

    static func expand(_ text: String, letters: String) -> [String] {
        return split(text.lowercased(), by: tokenSeparators)
            .map { return trimEdges($0) }
            .filter { token in
                return matches(maskRun, in: token) && token.contains { return $0.isLetter }
            }
            .flatMap { return expandToken($0, letters: letters) }
    }

    private static func expandToken(_ token: String, letters: String) -> [String] {
        let parts = split(token, by: maskRun, omittingEmpty: false)
        guard parts.count - 1 <= maxMaskRuns, let first = parts.first else {
            return [parts.joined()]
        }
        let replacements = [""] + letters.map { return String($0) }
        return parts.dropFirst().reduce([first]) { prefixes, part in
            return prefixes.flatMap { prefix in
                return replacements.map { return prefix + $0 + part }
            }
        }
    }

    private static func trimEdges(_ token: String) -> String {
        var result = Substring(token)
        while let first = result.first, edgePunctuation.contains(first) {
            result.removeFirst()
        }
        while let last = result.last, edgePunctuation.contains(last) {
            result.removeLast()
        }
        return String(result)
    }

    private static func matches(_ regex: NSRegularExpression?, in text: String) -> Bool {
        guard let regex else {
            return false
        }
        return regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)) != nil
    }

    private static func split(_ text: String, by regex: NSRegularExpression?, omittingEmpty: Bool = true) -> [String] {
        guard let regex else {
            return [text]
        }
        var parts: [String] = []
        var start = text.startIndex
        for match in regex.matches(in: text, range: NSRange(text.startIndex..., in: text)) {
            guard let range = Range(match.range, in: text) else {
                continue
            }
            parts.append(String(text[start..<range.lowerBound]))
            start = range.upperBound
        }
        parts.append(String(text[start...]))
        return omittingEmpty ? parts.filter { return !$0.isEmpty } : parts
    }
}
