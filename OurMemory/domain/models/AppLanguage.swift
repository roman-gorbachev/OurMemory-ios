import Foundation

nonisolated enum AppLanguage: String, CaseIterable, Hashable, Sendable {
    case russian = "ru"
    case belarusian = "be"
    case english = "en"
    case chinese = "zh-Hans"

    private static let chineseLanguageCode = "zh"

    var contentKey: String? {
        switch self {
        case .russian:
            return nil
        case .belarusian, .english:
            return rawValue
        case .chinese:
            return Self.chineseLanguageCode
        }
    }

    static var preferredBySystem: AppLanguage {
        for identifier in Locale.preferredLanguages {
            let code = Locale(identifier: identifier).language.languageCode?.identifier
            if let language = allCases.first(where: { return $0.rawValue == code || $0.contentKey == code }) {
                return language
            }
        }
        return .russian
    }
}
