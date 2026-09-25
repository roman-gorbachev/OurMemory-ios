import SwiftUI

struct AudioPlayerCard: View {
    private static let buttonSize: CGFloat = 52
    private static let secondsInMinute = 60
    private static let minimumDuration = 1.0

    let playbackState: AudioPlaybackState
    let onAction: (AudioAction) -> Void
    @State private var draggedPosition: Double?

    var body: some View {
        let isStarted = playbackState.currentAudio != nil
        let duration = playbackState.duration
        let position = min(max(draggedPosition ?? playbackState.currentPosition, 0), max(duration, 0))
        return VStack(alignment: .leading, spacing: Spacing.m) {
            HStack(spacing: Spacing.xl) {
                Button {
                    onAction(nextAction)
                } label: {
                    Image(systemName: playbackState.isPlaying ? "pause.fill" : "play.fill")
                        .font(.title2)
                        .foregroundStyle(Palette.onPrimary)
                        .frame(width: Self.buttonSize, height: Self.buttonSize)
                        .background(Circle().fill(Palette.primary))
                }
                .buttonStyle(.plain)
                .accessibilityLabel(playbackState.isPlaying ? "pause" : "play")
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text("listen_to_biography")
                        .appStyle(.titleMedium, weight: .bold)
                    if isStarted {
                        Text(verbatim: "\(Self.format(position)) / \(Self.format(duration))")
                            .appStyle(.bodySmall)
                            .monospacedDigit()
                    }
                }
                .foregroundStyle(Palette.onPrimaryContainer)
            }
            Slider(
                value: Binding(get: { return position }, set: { draggedPosition = $0 }),
                in: 0...max(duration, Self.minimumDuration),
                onEditingChanged: { isEditing in
                    if !isEditing, let draggedPosition {
                        onAction(.seek(draggedPosition))
                        self.draggedPosition = nil
                    }
                }
            )
            .tint(Palette.primary)
            .disabled(!isStarted || duration <= 0)
        }
        .padding(Spacing.xl)
        .background(RoundedRectangle(cornerRadius: CornerRadius.card).fill(Palette.primaryContainer))
        .padding(.horizontal, Spacing.screen)
    }

    private var nextAction: AudioAction {
        if playbackState.isPlaying {
            return .pause
        }
        return playbackState.currentAudio != nil ? .resume : .play
    }

    private static func format(_ seconds: Double) -> String {
        let total = Int(seconds.isFinite ? seconds : 0)
        return String(format: "%d:%02d", total / secondsInMinute, total % secondsInMinute)
    }
}

#Preview {
    AudioPlayerCard(playbackState: AudioPlaybackState()) { _ in }
}
