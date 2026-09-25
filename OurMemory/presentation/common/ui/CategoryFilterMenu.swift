import SwiftUI

struct CategoryFilterMenu: View {
    let checkedWar: Bool
    let checkedArt: Bool
    let onWarChange: (Bool) -> Void
    let onArtChange: (Bool) -> Void

    var body: some View {
        return Menu {
            Toggle(isOn: Binding(get: { return checkedWar }, set: onWarChange)) {
                Text(VeteranCategory.war.titleKey)
            }
            Toggle(isOn: Binding(get: { return checkedArt }, set: onArtChange)) {
                Text(VeteranCategory.art.titleKey)
            }
        } label: {
            Image(systemName: checkedWar && checkedArt ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
        }
    }
}
