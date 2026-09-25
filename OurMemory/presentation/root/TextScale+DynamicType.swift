import SwiftUI

extension TextScale {
    var dynamicTypeSize: DynamicTypeSize? {
        switch self {
        case .normal:
            return nil
        case .large:
            return .xLarge
        case .extraLarge:
            return .xxLarge
        }
    }
}
