import SwiftUI

struct InfoEntryRow: View {
    private static let mediaHeight: CGFloat = 140
    private static let paragraphLines = 3

    let entry: InfoEntry
    let onChange: (InfoEntry) -> Void

    var body: some View {
        switch entry.kind {
        case .paragraph(let text):
            TextField(
                "paragraph",
                text: Binding(get: { return text }, set: { onChange(InfoEntry(id: entry.id, kind: .paragraph(text: $0))) }),
                axis: .vertical
            )
            .lineLimit(Self.paragraphLines...)
        case .media(let url, let caption):
            VStack(alignment: .leading, spacing: Spacing.m) {
                RemoteImage(url: url)
                    .frame(height: Self.mediaHeight)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium, style: .continuous))
                TextField(
                    "caption",
                    text: Binding(get: { return caption }, set: { onChange(InfoEntry(id: entry.id, kind: .media(url: url, caption: $0))) })
                )
            }
            .padding(.vertical, Spacing.xs)
        }
    }
}
