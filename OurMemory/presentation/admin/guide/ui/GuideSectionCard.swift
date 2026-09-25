import SwiftUI

struct GuideSectionCard: View {
    private static let stepNumberSize: CGFloat = 24
    private static let expandedRotation = 180.0

    let section: GuideSection
    let isExpanded: Bool
    let onTap: () -> Void

    var body: some View {
        return VStack(alignment: .leading, spacing: Spacing.xl) {
            Button(action: onTap) {
                HStack(spacing: Spacing.l) {
                    SettingIcon(systemImage: section.systemImage)
                    Text(section.titleKey)
                        .appStyle(.titleMedium, weight: .bold)
                        .foregroundStyle(Palette.onSurface)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "chevron.down")
                        .foregroundStyle(Palette.onSurfaceVariant)
                        .rotationEffect(.degrees(isExpanded ? Self.expandedRotation : 0))
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            if isExpanded {
                VStack(alignment: .leading, spacing: Spacing.l) {
                    ForEach(Array(section.steps.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top, spacing: Spacing.l) {
                            Text(verbatim: String(index + 1))
                                .appStyle(.labelMedium, weight: .bold)
                                .foregroundStyle(Palette.onPrimary)
                                .frame(width: Self.stepNumberSize, height: Self.stepNumberSize)
                                .background(Circle().fill(Palette.primary))
                            Text(verbatim: step)
                                .appStyle(.bodyMedium)
                                .foregroundStyle(Palette.onSurface)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    Text(section.tipKey)
                        .appStyle(.bodyMedium)
                        .foregroundStyle(Palette.onPrimaryContainer)
                        .padding(Spacing.l)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(RoundedRectangle(cornerRadius: CornerRadius.large).fill(Palette.primaryContainer))
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(Spacing.xl)
        .background(RoundedRectangle(cornerRadius: CornerRadius.card).fill(Palette.containerLow))
    }
}
