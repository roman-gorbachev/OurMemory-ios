import SwiftUI

struct ExpandableTextSection: View {
    private static let collapsedMaxLines = 6

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
                        .appStyle(.body)
                        .foregroundStyle(Palette.onSurface)
                        .lineLimit(isExpanded ? nil : Self.collapsedMaxLines)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Button(isExpanded ? "rollup" : "expand") {
                    withAnimation(.snappy) {
                        isExpanded.toggle()
                    }
                }
                .appStyle(.subheadline, weight: .semibold)
            }
            .cardBackground()
        }
    }
}

#Preview {
    ExpandableTextSection(title: "biography", paragraphs: ["Первый абзац", "Второй абзац"])
        .background(Palette.groupedBackground)
}
