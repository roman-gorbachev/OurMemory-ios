import SwiftUI

enum Typography {
    case displaySmall
    case headlineLarge
    case headlineMedium
    case headlineSmall
    case titleLarge
    case titleMedium
    case titleSmall
    case bodyLarge
    case bodyMedium
    case bodySmall
    case labelLarge
    case labelMedium
    case labelSmall

    var size: CGFloat {
        switch self {
        case .displaySmall:
            return 36
        case .headlineLarge:
            return 32
        case .headlineMedium:
            return 28
        case .headlineSmall:
            return 24
        case .titleLarge:
            return 22
        case .titleMedium, .bodyLarge:
            return 16
        case .titleSmall, .bodyMedium, .labelLarge:
            return 14
        case .bodySmall, .labelMedium:
            return 12
        case .labelSmall:
            return 11
        }
    }

    var relativeStyle: Font.TextStyle {
        switch self {
        case .displaySmall, .headlineLarge:
            return .largeTitle
        case .headlineMedium:
            return .title
        case .headlineSmall, .titleLarge:
            return .title2
        case .titleMedium:
            return .headline
        case .titleSmall, .labelLarge:
            return .subheadline
        case .bodyLarge:
            return .body
        case .bodyMedium:
            return .callout
        case .bodySmall, .labelMedium:
            return .caption
        case .labelSmall:
            return .caption2
        }
    }

    var defaultWeight: Font.Weight {
        switch self {
        case .titleMedium, .titleSmall, .labelLarge, .labelMedium, .labelSmall:
            return .medium
        default:
            return .regular
        }
    }

    func font(weight: Font.Weight? = nil) -> Font {
        return Font.custom(Self.fontName(for: weight ?? defaultWeight), size: size, relativeTo: relativeStyle)
    }

    static func custom(size: CGFloat, weight: Font.Weight, relativeTo style: Font.TextStyle) -> Font {
        return Font.custom(fontName(for: weight), size: size, relativeTo: style)
    }

    private static func fontName(for weight: Font.Weight) -> String {
        switch weight {
        case .medium:
            return "Mulish-Medium"
        case .semibold, .bold, .heavy, .black:
            return "Mulish-Bold"
        default:
            return "Mulish-Regular"
        }
    }
}
