import Foundation

nonisolated extension KeyedDecodingContainer {
    func lenientString(forKey key: Key) -> String {
        if let value = try? decodeIfPresent(String.self, forKey: key) {
            return value
        }
        if let value = try? decodeIfPresent(Int64.self, forKey: key) {
            return String(value)
        }
        if let value = try? decodeIfPresent(Double.self, forKey: key) {
            return String(value)
        }
        return ""
    }

    func lenientDouble(forKey key: Key) -> Double {
        if let value = try? decodeIfPresent(Double.self, forKey: key) {
            return value
        }
        if let text = try? decodeIfPresent(String.self, forKey: key), let value = Double(text) {
            return value
        }
        return 0.0
    }

    func lenientInt64(forKey key: Key) -> Int64 {
        if let value = try? decodeIfPresent(Int64.self, forKey: key) {
            return value
        }
        if let value = try? decodeIfPresent(Double.self, forKey: key) {
            return Int64(value)
        }
        return 0
    }

    func lenientStrings(forKey key: Key) -> [String] {
        if let values = try? decodeIfPresent([String].self, forKey: key) {
            return values
        }
        if let values = try? decodeIfPresent([String: String].self, forKey: key) {
            return values.sorted { return $0.key.localizedStandardCompare($1.key) == .orderedAscending }.map { return $0.value }
        }
        return []
    }
}
