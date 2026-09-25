import SwiftUI

struct EditorGuideScreen: View {
    let onBack: () -> Void
    @State private var expanded: Set<GuideSection>

    init(initialSection: GuideSection?, onBack: @escaping () -> Void) {
        self.onBack = onBack
        _expanded = State(initialValue: Set([initialSection].compactMap { return $0 }))
    }

    var body: some View {
        return TopBarContainer(title: L10n.string("editor_guide"), onBack: onBack) {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.l) {
                    Text("add_burials_first_msg")
                        .appStyle(.bodyMedium)
                        .foregroundStyle(Palette.onSurfaceVariant)
                    ForEach(GuideSection.allCases, id: \.self) { section in
                        GuideSectionCard(section: section, isExpanded: expanded.contains(section)) {
                            withAnimation(.easeInOut) {
                                if expanded.contains(section) {
                                    expanded.remove(section)
                                } else {
                                    expanded.insert(section)
                                }
                            }
                        }
                    }
                }
                .padding(Spacing.screen)
            }
        }
    }
}

#Preview {
    EditorGuideScreen(initialSection: .veteran) {}
}
