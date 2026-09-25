import SwiftUI

struct InfoEntryEditor: View {
    private static let mediaHeight: CGFloat = 160
    private static let paragraphLines = 3

    let entry: InfoEntry
    let canMoveUp: Bool
    let canMoveDown: Bool
    let onChange: (InfoEntry) -> Void
    let onMove: (Int) -> Void
    let onRemove: () -> Void

    var body: some View {
        return VStack(alignment: .leading, spacing: Spacing.m) {
            switch entry.kind {
            case .paragraph(let text):
                AppTextField(
                    label: "paragraph",
                    text: Binding(get: { return text }, set: { onChange(InfoEntry(id: entry.id, kind: .paragraph(text: $0))) }),
                    axis: .vertical,
                    minLines: Self.paragraphLines
                )
            case .media(let url, let caption):
                RemoteImage(url: url)
                    .frame(maxWidth: .infinity)
                    .frame(height: Self.mediaHeight)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small))
                AppTextField(
                    label: "caption",
                    text: Binding(get: { return caption }, set: { onChange(InfoEntry(id: entry.id, kind: .media(url: url, caption: $0))) })
                )
            }
            HStack(spacing: Spacing.xl) {
                Button {
                    onMove(-1)
                } label: {
                    Image(systemName: "chevron.up")
                }
                .disabled(!canMoveUp)
                .accessibilityLabel("move_up")
                Button {
                    onMove(1)
                } label: {
                    Image(systemName: "chevron.down")
                }
                .disabled(!canMoveDown)
                .accessibilityLabel("move_down")
                Button(action: onRemove) {
                    Image(systemName: "xmark")
                        .foregroundStyle(Palette.error)
                }
                .accessibilityLabel("delete")
            }
            .foregroundStyle(Palette.onSurfaceVariant)
        }
        .padding(Spacing.l)
        .background(RoundedRectangle(cornerRadius: CornerRadius.large).fill(Palette.surface))
        .shadow(color: Palette.shadow, radius: Shadow.smallRadius, y: Shadow.offsetY)
    }
}
