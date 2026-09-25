import SwiftUI

extension FeedbackType {
    var titleKey: LocalizedStringKey {
        switch self {
        case .dataError:
            return "data_error"
        case .suggestion:
            return "suggestion"
        case .other:
            return "other"
        }
    }
}
