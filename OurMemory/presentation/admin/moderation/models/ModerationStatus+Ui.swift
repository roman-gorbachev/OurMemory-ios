import SwiftUI

extension ModerationStatus {
    var titleKey: LocalizedStringKey {
        return LocalizedStringKey(titleResource)
    }

    var titleResource: String {
        switch self {
        case .pending:
            return "awaiting_review"
        case .approved:
            return "approved"
        case .rejected:
            return "rejected"
        }
    }
}
