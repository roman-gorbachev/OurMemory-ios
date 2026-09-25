import SwiftUI

struct TourStopRow: View {
    private static let numberSize: CGFloat = 32
    private static let audioButtonSize: CGFloat = 40
    private static let collapsedTextLines = 3

    let stop: TourStopUi
    let isSelected: Bool
    let isPlaying: Bool
    let isVisited: Bool
    let onTap: () -> Void
    let onAudioTap: () -> Void
    let onVisitedToggle: () -> Void

    var body: some View {
        return HStack(alignment: .top, spacing: Spacing.l) {
            Text(verbatim: String(stop.number))
                .appStyle(.labelLarge, weight: .bold)
                .foregroundStyle(Palette.onPrimary)
                .frame(width: Self.numberSize, height: Self.numberSize)
                .background(Circle().fill(Palette.primary))
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(verbatim: stop.title.isBlank ? stop.type.titleText : stop.title)
                    .appStyle(.titleMedium, weight: .bold)
                    .foregroundStyle(Palette.onSurface)
                PlotNumberText(burial: stop.burial)
                if !stop.text.isBlank {
                    Text(verbatim: stop.text)
                        .appStyle(.bodyMedium)
                        .foregroundStyle(Palette.onSurfaceVariant)
                        .lineLimit(isSelected ? nil : Self.collapsedTextLines)
                }
                Button(action: onVisitedToggle) {
                    HStack(spacing: Spacing.m) {
                        Image(systemName: isVisited ? "checkmark.square.fill" : "square")
                            .foregroundStyle(isVisited ? Palette.primary : Palette.onSurfaceVariant)
                        Text("visited")
                            .appStyle(.labelLarge)
                            .foregroundStyle(Palette.onSurfaceVariant)
                    }
                    .padding(.vertical, Spacing.xs)
                }
                .buttonStyle(.plain)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            if stop.audio != nil {
                Button(action: onAudioTap) {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .foregroundStyle(Palette.onPrimary)
                        .frame(width: Self.audioButtonSize, height: Self.audioButtonSize)
                        .background(Circle().fill(Palette.primary))
                }
                .buttonStyle(.plain)
                .accessibilityLabel(isPlaying ? "pause" : "play")
            }
        }
        .padding(Spacing.l)
        .background(RoundedRectangle(cornerRadius: CornerRadius.extraLarge).fill(isSelected ? Palette.primaryContainer : Palette.container))
        .contentShape(RoundedRectangle(cornerRadius: CornerRadius.extraLarge))
        .onTapGesture(perform: onTap)
    }
}
