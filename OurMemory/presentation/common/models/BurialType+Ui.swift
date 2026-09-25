import SwiftUI

extension BurialType {
    var titleKey: LocalizedStringKey {
        switch self {
        case .grave:
            return "grave"
        case .massGrave:
            return "mass_grave"
        case .monument:
            return "monument"
        }
    }

    var titleText: String {
        switch self {
        case .grave:
            return L10n.string("grave")
        case .massGrave:
            return L10n.string("mass_grave")
        case .monument:
            return L10n.string("monument")
        }
    }
}
