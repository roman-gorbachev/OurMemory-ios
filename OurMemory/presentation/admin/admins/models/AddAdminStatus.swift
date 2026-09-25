import SwiftUI

enum AddAdminStatus: Hashable {
    case idle
    case adding
    case added
    case accountNotFound
    case alreadyAdmin
    case failed

    var messageKey: LocalizedStringKey? {
        switch self {
        case .idle, .adding:
            return nil
        case .added:
            return "administrator_added_msg"
        case .accountNotFound:
            return "account_not_found_msg"
        case .alreadyAdmin:
            return "already_administrator_msg"
        case .failed:
            return "failed_to_save_msg"
        }
    }
}
