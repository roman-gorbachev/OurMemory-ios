import SwiftUI

enum ReviewFailure: Hashable {
    case network
    case noPermission

    var messageKey: LocalizedStringKey {
        switch self {
        case .network:
            return "failed_to_save_msg"
        case .noPermission:
            return "no_permission_to_change_request_msg"
        }
    }
}
