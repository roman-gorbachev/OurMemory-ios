import SwiftUI

enum AdminLoginError: Hashable {
    case wrongCredentials
    case noAdminRights
    case connection

    var messageKey: LocalizedStringKey {
        switch self {
        case .wrongCredentials:
            return "wrong_email_or_password_msg"
        case .noAdminRights:
            return "no_admin_rights_msg"
        case .connection:
            return "failed_to_sign_in_msg"
        }
    }
}
