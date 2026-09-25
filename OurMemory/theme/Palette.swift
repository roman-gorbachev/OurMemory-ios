import SwiftUI
import UIKit

enum Palette {
    static let primary = Color("Primary")
    static let onPrimary = Color.white
    static let primaryContainer = Color("Primary").opacity(0.12)
    static let onPrimaryContainer = Color("Primary")
    static let secondary = Color("Secondary")
    static let onSecondary = Color.white
    static let background = Color(uiColor: .systemBackground)
    static let groupedBackground = Color(uiColor: .systemGroupedBackground)
    static let onBackground = Color(uiColor: .label)
    static let surface = Color(uiColor: .secondarySystemGroupedBackground)
    static let onSurface = Color(uiColor: .label)
    static let surfaceVariant = Color(uiColor: .tertiarySystemGroupedBackground)
    static let onSurfaceVariant = Color(uiColor: .secondaryLabel)
    static let tertiaryLabel = Color(uiColor: .tertiaryLabel)
    static let containerLowest = Color(uiColor: .systemBackground)
    static let containerLow = Color(uiColor: .secondarySystemGroupedBackground)
    static let container = Color(uiColor: .secondarySystemBackground)
    static let containerHigh = Color(uiColor: .tertiarySystemFill)
    static let containerHighest = Color(uiColor: .systemGray5)
    static let outline = Color(uiColor: .separator)
    static let outlineVariant = Color(uiColor: .separator)
    static let error = Color(uiColor: .systemRed)
    static let success = Color(uiColor: .systemGreen)
    static let brandRed = Color(red: 0x7F / 255.0, green: 0x04 / 255.0, blue: 0x10 / 255.0)
    static let brandBrightRed = Color(red: 0xBB / 255.0, green: 0x10 / 255.0, blue: 0x20 / 255.0)
    static let white = Color.white
    static let black = Color.black
    static let scrimTop = Color.black.opacity(0.45)
    static let scrimBottom = Color.black.opacity(0.75)
    static let dimmed = Color.black.opacity(0.5)
    static let captionBackground = Color.black.opacity(0.6)
    static let shadow = Color.black.opacity(0.12)
    static let accuracyFill = brandRed.opacity(0.15)
    static let accuracyStroke = brandRed.opacity(0.4)
}
