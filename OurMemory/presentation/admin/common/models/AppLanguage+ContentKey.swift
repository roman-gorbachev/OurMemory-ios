import Foundation

extension AppLanguage {
    static func translated<Value>(_ translations: [String: Value]) -> [AppLanguage: Value] {
        return Dictionary(uniqueKeysWithValues: allCases.compactMap { language in
            guard let key = language.contentKey, let value = translations[key] else {
                return nil
            }
            return (language, value)
        })
    }

    static func stored<Value>(_ translations: [AppLanguage: Value]) -> [String: Value] {
        return Dictionary(uniqueKeysWithValues: translations.compactMap { language, value in
            guard let key = language.contentKey else {
                return nil
            }
            return (key, value)
        })
    }
}
