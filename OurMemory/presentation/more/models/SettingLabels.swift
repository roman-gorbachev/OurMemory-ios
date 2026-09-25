import SwiftUI

extension ThemeMode {
    var titleKey: LocalizedStringKey {
        switch self {
        case .system:
            return "as_in_system"
        case .light:
            return "light"
        case .dark:
            return "dark"
        }
    }
}

extension TextScale {
    var titleKey: LocalizedStringKey {
        switch self {
        case .normal:
            return "normal"
        case .large:
            return "large"
        case .extraLarge:
            return "extra_large"
        }
    }
}

extension AppLanguage {
    var titleKey: LocalizedStringKey {
        switch self {
        case .russian:
            return "russian"
        case .belarusian:
            return "belarusian"
        case .english:
            return "english"
        case .chinese:
            return "chinese"
        }
    }
}
