import SwiftUI

struct TourStopRow: View {
    private static let numberSize: CGFloat = 30
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
            Button(action: onVisitedToggle) {
                ZStack {
                    Circle().fill(isVisited ? Palette.success : Palette.primary)
                    if isVisited {
                        Image(systemName: "checkmark")
                            .appStyle(.subheadline, weight: .bold)
                    } else {
                        Text(verbatim: String(stop.number))
                            .appStyle(.subheadline, weight: .bold)
                    }
                }
                .foregroundStyle(Palette.white)
                .frame(width: Self.numberSize, height: Self.numberSize)
                .contentTransition(.symbolEffect(.replace))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("visited")
            .accessibilityAddTraits(isVisited ? .isSelected : [])
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(verbatim: stop.title.isBlank ? stop.type.titleText : stop.title)
                    .appStyle(.headline)
                    .foregroundStyle(Palette.onSurface)
                PlotNumberText(burial: stop.burial)
                    .appStyle(.subheadline)
                    .foregroundStyle(Palette.onSurfaceVariant)
                if !stop.text.isBlank {
                    Text(verbatim: stop.text)
                        .appStyle(.callout)
                        .foregroundStyle(Palette.onSurfaceVariant)
                        .lineLimit(isSelected ? nil : Self.collapsedTextLines)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .onTapGesture(perform: onTap)
            if stop.audio != nil {
                Button(action: onAudioTap) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(Palette.primary)
                        .contentTransition(.symbolEffect(.replace))
                }
                .buttonStyle(.plain)
                .accessibilityLabel(isPlaying ? "pause" : "play")
            }
        }
        .padding(.vertical, Spacing.xs)
        .swipeActions(edge: .leading) {
            Button(action: onVisitedToggle) {
                Label("visited", systemImage: isVisited ? "arrow.uturn.backward" : "checkmark")
            }
            .tint(Palette.success)
        }
    }
}
