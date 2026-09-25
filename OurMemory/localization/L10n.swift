import Foundation

enum L10n {
    private static let tableName = "Localizable"
    private static let bundleExtension = "lproj"

    private static var bundle = Bundle.main

    static var language = AppLanguage.russian {
        didSet {
            let path = Bundle.main.path(forResource: language.rawValue, ofType: bundleExtension)
            bundle = path.flatMap(Bundle.init(path:)) ?? .main
        }
    }

    static var locale: Locale {
        return Locale(identifier: language.rawValue)
    }

    static func string(_ key: String) -> String {
        return bundle.localizedString(forKey: key, value: nil, table: tableName)
    }

    static func format(_ key: String, _ arguments: CVarArg...) -> String {
        return String(format: string(key), locale: locale, arguments: arguments)
    }
}
