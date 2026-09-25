import SwiftUI

struct AudioAttachmentRow: View {
    let audioUrl: String
    let onPicked: (URL) -> Void
    let onRemove: () -> Void

    var body: some View {
        return HStack(spacing: Spacing.m) {
            Text(audioUrl.isBlank ? "no_audio" : "audio_attached")
                .appStyle(.bodyMedium)
                .foregroundStyle(Palette.onSurface)
                .frame(maxWidth: .infinity, alignment: .leading)
            if !audioUrl.isBlank {
                Button("delete", action: onRemove)
                    .appStyle(.labelLarge, weight: .semibold)
                    .foregroundStyle(Palette.error)
            }
            AudioPickButton(onPicked: onPicked)
        }
    }
}
