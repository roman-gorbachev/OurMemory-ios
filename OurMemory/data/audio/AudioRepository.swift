import Combine
import Foundation

final class AudioRepository {
    private let player: AudioPlayer
    private var ownedAudioIds = Set<String>()

    init(player: AudioPlayer) {
        self.player = player
    }

    var playbackStatePublisher: AnyPublisher<AudioPlaybackState, Never> {
        return player.statePublisher
            .map { [weak self] state in
                guard let id = state.currentAudio?.id, self?.ownedAudioIds.contains(id) == true else {
                    return AudioPlaybackState()
                }
                return state
            }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    func play(_ audio: AudioItem) {
        ownedAudioIds.insert(audio.id)
        player.play(audio)
    }

    func pause() {
        player.pause()
    }

    func resume() {
        player.resume()
    }

    func stop() {
        player.stop()
    }

    func seek(to seconds: TimeInterval) {
        player.seek(to: seconds)
    }

    func release() {
        if let id = player.state.currentAudio?.id, ownedAudioIds.contains(id) {
            player.stop()
        }
    }
}
