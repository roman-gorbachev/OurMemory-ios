import SwiftUI

struct AudioAttachmentRow: View {
    let audioUrl: String
    let onPicked: (URL) -> Void
    let onRemove: () -> Void

    var body: some View {
        return HStack(spacing: Spacing.m) {
            Label(audioUrl.isBlank ? "no_audio" : "audio_attached", systemImage: audioUrl.isBlank ? "waveform.slash" : "waveform")
                .foregroundStyle(audioUrl.isBlank ? Palette.onSurfaceVariant : Palette.onSurface)
                .frame(maxWidth: .infinity, alignment: .leading)
            if !audioUrl.isBlank {
                Button(role: .destructive, action: onRemove) {
                    Image(systemName: "trash")
                }
                .buttonStyle(.borderless)
                .accessibilityLabel("delete")
            }
            AudioPickButton(onPicked: onPicked)
        }
    }
}
