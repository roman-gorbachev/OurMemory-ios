import Foundation

nonisolated enum VeteranLink {
    static let baseUrl = "https://chatroom-85fb8.web.app/veteran"
    private static let queryStart: Character = "?"
    private static let pathSeparator: Character = "/"

    static func url(forVeteranId veteranId: String) -> URL? {
        return URL(string: "\(baseUrl)\(pathSeparator)\(veteranId)")
    }

    static func parseVeteranId(_ rawValue: String) -> String? {
        let prefix = "\(baseUrl)\(pathSeparator)"
        let trimmed = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.hasPrefix(prefix) else {
            return nil
        }
        var id = String(trimmed.dropFirst(prefix.count))
        if let queryIndex = id.firstIndex(of: queryStart) {
            id = String(id[..<queryIndex])
        }
        while id.last == pathSeparator {
            id.removeLast()
        }
        guard !id.trimmingCharacters(in: .whitespaces).isEmpty, !id.contains(pathSeparator) else {
            return nil
        }
        return id
    }
}
