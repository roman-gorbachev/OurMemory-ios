import Foundation

enum AudioAction {
    case play
    case pause
    case resume
    case stop
    case seek(TimeInterval)
}
