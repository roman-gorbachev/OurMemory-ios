import Foundation

nonisolated enum AddAdminResult: Hashable, Sendable {
    case added
    case accountNotFound
    case alreadyAdmin
}
