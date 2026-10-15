import Foundation

nonisolated enum VeteranNameMatcher {
    private static let surnameWeight = 3
    private static let givenNameWeight = 2
    private static let yearWeight = 1
    private static let minimumScore = 3
    private static let maximumCandidates = 3
    private static let minimumWordLength = 2
    private static let yearLength = 4
    private static let exactMatchLengthLimit = 4
    private static let singleTypoLengthLimit = 7
    private static let singleTypo = 1
    private static let doubleTypo = 2
    private static let editCost = 1
    private static let lookalikes: [Character: Character] = [
        "a": "а", "b": "в", "c": "с", "e": "е", "h": "н", "k": "к",
        "m": "м", "o": "о", "p": "р", "t": "т", "x": "х", "y": "у", "ё": "е"
    ]

    static func candidates(in recognizedText: String, among veterans: [Veteran]) -> [Veteran] {
        let words = normalizedWords(in: recognizedText)
        let recognizedYears = Set(words.filter(isYear))
        let recognizedNames = words.filter { return !isYear($0) && $0.count >= minimumWordLength }
        guard !recognizedNames.isEmpty else {
            return []
        }
        let scored = veterans.compactMap { veteran -> (veteran: Veteran, score: Int)? in
            let score = nameScore(of: veteran, recognizedNames: recognizedNames)
                + yearScore(of: veteran, recognizedYears: recognizedYears)
            return score >= minimumScore ? (veteran, score) : nil
        }
        return scored
            .sorted { return $0.score > $1.score }
            .prefix(maximumCandidates)
            .map { return $0.veteran }
    }

    private static func nameScore(of veteran: Veteran, recognizedNames: [String]) -> Int {
        return veteran.allNames.map { name in
            let parts = normalizedWords(in: name).filter { return $0.count >= minimumWordLength }
            return parts.enumerated().reduce(0) { score, part in
                guard recognizedNames.contains(where: { return isSimilar($0, to: part.element) }) else {
                    return score
                }
                return score + (part.offset == 0 ? surnameWeight : givenNameWeight)
            }
        }.max() ?? 0
    }

    private static func yearScore(of veteran: Veteran, recognizedYears: Set<String>) -> Int {
        let veteranYears = Set(
            [veteran.birthDate, veteran.deathDate, veteran.years]
                .flatMap { return normalizedWords(in: $0) }
                .filter(isYear)
        )
        return veteranYears.intersection(recognizedYears).count * yearWeight
    }

    private static func normalizedWords(in text: String) -> [String] {
        let mapped = String(text.lowercased().map { return lookalikes[$0] ?? $0 })
        return mapped
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { return !$0.isEmpty }
    }

    private static func isYear(_ word: String) -> Bool {
        return word.count == yearLength && word.allSatisfy(\.isNumber)
    }

    private static func isSimilar(_ word: String, to namePart: String) -> Bool {
        let allowedTypos: Int
        if namePart.count <= exactMatchLengthLimit {
            allowedTypos = 0
        } else if namePart.count <= singleTypoLengthLimit {
            allowedTypos = singleTypo
        } else {
            allowedTypos = doubleTypo
        }
        guard abs(word.count - namePart.count) <= allowedTypos else {
            return false
        }
        return editDistance(Array(word), Array(namePart)) <= allowedTypos
    }

    private static func editDistance(_ source: [Character], _ target: [Character]) -> Int {
        guard !source.isEmpty else {
            return target.count
        }
        guard !target.isEmpty else {
            return source.count
        }
        var previous = Array(0...target.count)
        for sourceIndex in source.indices {
            var current = [sourceIndex + editCost] + Array(repeating: 0, count: target.count)
            for targetIndex in target.indices {
                let substitution = source[sourceIndex] == target[targetIndex] ? 0 : editCost
                current[targetIndex + editCost] = min(
                    previous[targetIndex + editCost] + editCost,
                    current[targetIndex] + editCost,
                    previous[targetIndex] + substitution
                )
            }
            previous = current
        }
        return previous[target.count]
    }
}
