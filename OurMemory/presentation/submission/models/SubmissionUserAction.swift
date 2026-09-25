import Foundation

enum SubmissionUserAction {
    case textChanged(String)
    case contactChanged(String)
    case consentChanged(Bool)
    case photosPicked([Data])
    case photoRemoved(UUID)
    case send
}
