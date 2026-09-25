import SwiftUI

enum EditorFailure: Hashable, Identifiable {
    case save
    case upload
    case uploadDenied

    init(uploadError: Error) {
        self = (uploadError as? MediaError) == .uploadDenied ? .uploadDenied : .upload
    }

    var id: Self {
        return self
    }

    var messageKey: LocalizedStringKey {
        switch self {
        case .save:
            return "failed_to_save_msg"
        case .upload:
            return "failed_to_upload_file_msg"
        case .uploadDenied:
            return "no_permission_to_upload_files_msg"
        }
    }
}
