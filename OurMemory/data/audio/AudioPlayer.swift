import AVFoundation
import Combine
import Foundation
import MediaPlayer

final class AudioPlayer {
    private static let positionUpdateSeconds = 0.5
    private static let preferredTimescale: CMTimeScale = 600

    private let player = AVPlayer()
    private let stateSubject = CurrentValueSubject<AudioPlaybackState, Never>(AudioPlaybackState())
    private var cancellables = Set<AnyCancellable>()
    private var itemCancellables = Set<AnyCancellable>()
    private var timeObserver: Any?
    private var isRemoteCommandsConfigured = false

    init() {
        player.publisher(for: \.timeControlStatus)
            .sink { [weak self] status in
                self?.updatePlaying(status == .playing || status == .waitingToPlayAtSpecifiedRate)
            }
            .store(in: &cancellables)
        timeObserver = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: Self.positionUpdateSeconds, preferredTimescale: Self.preferredTimescale),
            queue: .main
        ) { [weak self] time in
            MainActor.assumeIsolated {
                self?.updatePosition(time.seconds)
            }
        }
    }

    var statePublisher: AnyPublisher<AudioPlaybackState, Never> {
        return stateSubject.eraseToAnyPublisher()
    }

    var state: AudioPlaybackState {
        return stateSubject.value
    }

    func play(_ audio: AudioItem) {
        configureSession()
        configureRemoteCommands()
        itemCancellables.removeAll()
        let item = AVPlayerItem(url: audio.url)
        item.publisher(for: \.status)
            .sink { [weak self] status in
                if status == .failed {
                    self?.reset()
                } else if status == .readyToPlay {
                    self?.updateDuration(item.duration.seconds)
                }
            }
            .store(in: &itemCancellables)
        NotificationCenter.default.publisher(for: AVPlayerItem.didPlayToEndTimeNotification, object: item)
            .sink { [weak self] _ in self?.reset() }
            .store(in: &itemCancellables)
        stateSubject.send(AudioPlaybackState(isPlaying: true, currentAudio: audio))
        player.replaceCurrentItem(with: item)
        player.play()
        updateNowPlaying()
    }

    func pause() {
        player.pause()
        var state = stateSubject.value
        state.isPlaying = false
        state.currentPosition = player.currentTime().seconds.finiteOrZero
        stateSubject.send(state)
        updateNowPlaying()
    }

    func resume() {
        player.play()
    }

    func stop() {
        reset()
    }

    func seek(to seconds: TimeInterval) {
        var state = stateSubject.value
        state.currentPosition = seconds
        stateSubject.send(state)
        player.seek(to: CMTime(seconds: seconds, preferredTimescale: Self.preferredTimescale))
        updateNowPlaying()
    }

    private func reset() {
        itemCancellables.removeAll()
        player.pause()
        player.replaceCurrentItem(with: nil)
        stateSubject.send(AudioPlaybackState())
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }

    private func updatePlaying(_ isPlaying: Bool) {
        guard stateSubject.value.currentAudio != nil, stateSubject.value.isPlaying != isPlaying else {
            return
        }
        var state = stateSubject.value
        state.isPlaying = isPlaying
        stateSubject.send(state)
        updateNowPlaying()
    }

    private func updatePosition(_ seconds: TimeInterval) {
        guard stateSubject.value.currentAudio != nil, stateSubject.value.isPlaying else {
            return
        }
        var state = stateSubject.value
        state.currentPosition = seconds.finiteOrZero
        stateSubject.send(state)
    }

    private func updateDuration(_ seconds: TimeInterval) {
        guard seconds.isFinite else {
            return
        }
        var state = stateSubject.value
        state.duration = seconds
        stateSubject.send(state)
        updateNowPlaying()
    }

    private func configureSession() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio)
        try? AVAudioSession.sharedInstance().setActive(true)
    }

    private func updateNowPlaying() {
        let state = stateSubject.value
        guard let audio = state.currentAudio else {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
            return
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: audio.title,
            MPMediaItemPropertyArtist: audio.subtitle,
            MPMediaItemPropertyPlaybackDuration: state.duration,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: player.currentTime().seconds.finiteOrZero,
            MPNowPlayingInfoPropertyPlaybackRate: state.isPlaying ? 1.0 : 0.0
        ]
    }

    private func configureRemoteCommands() {
        guard !isRemoteCommandsConfigured else {
            return
        }
        isRemoteCommandsConfigured = true
        let center = MPRemoteCommandCenter.shared()
        center.playCommand.addTarget { [weak self] _ in
            self?.resume()
            return .success
        }
        center.pauseCommand.addTarget { [weak self] _ in
            self?.pause()
            return .success
        }
        center.togglePlayPauseCommand.addTarget { [weak self] _ in
            guard let self else {
                return .commandFailed
            }
            if state.isPlaying {
                pause()
            } else {
                resume()
            }
            return .success
        }
        center.changePlaybackPositionCommand.addTarget { [weak self] event in
            guard let event = event as? MPChangePlaybackPositionCommandEvent else {
                return .commandFailed
            }
            self?.seek(to: event.positionTime)
            return .success
        }
    }
}

private extension Double {
    var finiteOrZero: Double {
        return isFinite ? self : 0
    }
}
