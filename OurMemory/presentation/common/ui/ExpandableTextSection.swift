import SwiftUI

struct ExpandableTextSection: View {
    private static let collapsedMaxLines = 8

    let title: LocalizedStringKey
    let paragraphs: [String]
    @State private var isExpanded = false

    var body: some View {
        let visible = isExpanded ? paragraphs : Array(paragraphs.prefix(1))
        return VStack(alignment: .leading, spacing: 0) {
            SectionTitle(text: title)
            VStack(alignment: .leading, spacing: Spacing.l) {
                ForEach(Array(visible.enumerated()), id: \.offset) { _, paragraph in
                    Text(verbatim: paragraph)
                        .appStyle(.bodyLarge)
                        .foregroundStyle(Palette.onSurface)
                        .lineLimit(isExpanded ? nil : Self.collapsedMaxLines)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal, Spacing.screen)
            Button {
                withAnimation(.easeInOut) {
                    isExpanded.toggle()
                }
            } label: {
                Text(isExpanded ? "rollup" : "expand")
                    .appStyle(.labelLarge, weight: .semibold)
                    .foregroundStyle(Palette.primary)
            }
            .padding(.horizontal, Spacing.screen)
            .padding(.vertical, Spacing.m)
        }
    }
}

#Preview {
    ExpandableTextSection(title: "biography", paragraphs: ["Первый абзац", "Второй абзац"])
}
