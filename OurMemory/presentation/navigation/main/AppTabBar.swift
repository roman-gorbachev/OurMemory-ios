import SwiftUI

struct AppTabBar: View {
    private static let innerPadding: CGFloat = 4
    private static let iconSize: CGFloat = 20
    private static let selectionAnimationSeconds = 0.3

    let tabs: [TopLevelTab]
    let selectedTab: TopLevelTab
    let onSelect: (TopLevelTab) -> Void

    var body: some View {
        return HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                item(tab)
                if tab != tabs.last {
                    Spacer(minLength: 0)
                }
            }
        }
        .padding(Self.innerPadding)
        .frame(height: Spacing.tabBarHeight)
        .background(Capsule().fill(Palette.barBackground))
        .shadow(color: Palette.shadow, radius: Shadow.largeRadius, y: Shadow.mediumRadius)
        .padding(.horizontal, Spacing.xl)
        .padding(.vertical, Spacing.m)
        .animation(.spring(duration: Self.selectionAnimationSeconds), value: selectedTab)
    }

    private func item(_ tab: TopLevelTab) -> some View {
        let isSelected = tab == selectedTab
        return Button {
            onSelect(tab)
        } label: {
            HStack(spacing: Spacing.s) {
                Image(systemName: tab.systemImage)
                    .font(.system(size: Self.iconSize, weight: .medium))
                if isSelected {
                    Text(tab.titleKey)
                        .appStyle(.labelLarge, weight: .semibold)
                        .lineLimit(1)
                        .transition(.opacity.combined(with: .move(edge: .leading)))
                }
            }
            .foregroundStyle(isSelected ? Palette.primary : Palette.onSurfaceVariant)
            .padding(.horizontal, Spacing.l)
            .frame(maxHeight: .infinity)
            .background(Capsule().fill(isSelected ? Palette.primaryContainer : Color.clear))
            .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(tab.titleKey)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    AppTabBar(tabs: TopLevelTab.allCases, selectedTab: .veterans) { _ in }
}
