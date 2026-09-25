import SwiftUI

extension VeteranCategory {
    var titleKey: LocalizedStringKey {
        switch self {
        case .war:
            return "heroUSSR"
        case .art:
            return "art"
        }
    }
}
