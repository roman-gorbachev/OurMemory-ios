import SwiftUI

struct CategoryFilter: View {
    let checkedWar: Bool
    let checkedArt: Bool
    let onWarChange: (Bool) -> Void
    let onArtChange: (Bool) -> Void

    var body: some View {
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.m) {
                FilterToggle(title: VeteranCategory.war.titleKey, isSelected: checkedWar) { onWarChange(!checkedWar) }
                FilterToggle(title: VeteranCategory.art.titleKey, isSelected: checkedArt) { onArtChange(!checkedArt) }
            }
            .padding(.horizontal, Spacing.screen)
            .padding(.vertical, Spacing.xs)
        }
    }
}

#Preview {
    CategoryFilter(checkedWar: true, checkedArt: false, onWarChange: { _ in }, onArtChange: { _ in })
}
