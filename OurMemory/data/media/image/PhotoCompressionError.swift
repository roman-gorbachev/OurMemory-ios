import Foundation

nonisolated enum PhotoCompressionError: Error {
    case unreadableImage
    case encodingFailed
}
