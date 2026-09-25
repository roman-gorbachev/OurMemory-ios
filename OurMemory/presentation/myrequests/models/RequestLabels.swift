import SwiftUI

extension RequestStatus {
    var titleKey: LocalizedStringKey {
        switch self {
        case .inReview:
            return "awaiting_review"
        case .approved:
            return "added_to_card"
        case .rejected:
            return "rejected"
        case .reviewed:
            return "reviewed"
        }
    }
}

extension RequestKind {
    var titleKey: LocalizedStringKey {
        switch self {
        case .submission:
            return "materials_for_card"
        case .feedback:
            return "message"
        }
    }
}
