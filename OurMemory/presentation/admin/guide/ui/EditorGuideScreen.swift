import SwiftUI

struct EditorGuideScreen: View {
    private static let stepNumberSize: CGFloat = 24

    @State private var expanded: Set<GuideSection>

    init(initialSection: GuideSection?) {
        _expanded = State(initialValue: Set([initialSection].compactMap { return $0 }))
    }

    var body: some View {
        return List {
            Section {
                Text("add_burials_first_msg")
                    .appStyle(.subheadline)
                    .foregroundStyle(Palette.onSurfaceVariant)
            }
            ForEach(GuideSection.allCases, id: \.self) { section in
                Section {
                    DisclosureGroup(isExpanded: binding(for: section)) {
                        ForEach(Array(section.steps.enumerated()), id: \.offset) { index, step in
                            HStack(alignment: .firstTextBaseline, spacing: Spacing.l) {
                                Text(verbatim: String(index + 1))
                                    .appStyle(.caption, weight: .bold)
                                    .foregroundStyle(Palette.white)
                                    .frame(width: Self.stepNumberSize, height: Self.stepNumberSize)
                                    .background(Circle().fill(Palette.primary))
                                Text(verbatim: step)
                                    .appStyle(.callout)
                            }
                        }
                        Label(section.tipKey, systemImage: "lightbulb")
                            .appStyle(.callout)
                            .foregroundStyle(Palette.primary)
                    } label: {
                        Label {
                            Text(section.titleKey).appStyle(.headline)
                        } icon: {
                            SettingsIcon(systemImage: section.systemImage)
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("editor_guide")
    }

    private func binding(for section: GuideSection) -> Binding<Bool> {
        return Binding(
            get: { return expanded.contains(section) },
            set: { isExpanded in
                if isExpanded {
                    expanded.insert(section)
                } else {
                    expanded.remove(section)
                }
            }
        )
    }
}

#Preview {
    NavigationStack {
        EditorGuideScreen(initialSection: .veteran)
    }
}
