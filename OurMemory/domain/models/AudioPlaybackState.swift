import Foundation

nonisolated struct AudioPlaybackState: Hashable, Sendable {
    var isPlaying = false
    var currentAudio: AudioItem?
    var currentPosition: TimeInterval = 0
    var duration: TimeInterval = 0
}
