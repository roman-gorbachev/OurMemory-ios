import SwiftUI

extension PhotoCheckResult {
    var rejectionKey: LocalizedStringKey {
        switch self {
        case .unreadable:
            return "could_not_open_photo_msg"
        case .allowed, .blocked:
            return "photo_did_not_pass_check_msg"
        }
    }
}
