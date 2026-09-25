import SwiftUI

struct AdminAddButton: View {
    let title: LocalizedStringKey
    let action: () -> Void

    var body: some View {
        return Button(action: action) {
            Label(title, systemImage: "plus")
                .appStyle(.labelLarge, weight: .bold)
                .foregroundStyle(Palette.onPrimaryContainer)
                .padding(.horizontal, Spacing.xl)
                .padding(.vertical, Spacing.xl)
                .background(RoundedRectangle(cornerRadius: CornerRadius.extraLarge).fill(Palette.primaryContainer))
                .shadow(color: Palette.shadow, radius: Shadow.mediumRadius, y: Shadow.offsetY)
        }
        .buttonStyle(.plain)
        .padding(Spacing.xl)
    }
}
