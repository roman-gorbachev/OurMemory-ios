import Foundation

nonisolated enum ModerationError: Error {
    case veteranNotFound(String)
    case permissionDenied
}
