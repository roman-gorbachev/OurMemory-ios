import SwiftUI

struct GuideHintCard: View {
    private static let padding: CGFloat = 14

    let title: LocalizedStringKey
    let action: () -> Void

    var body: some View {
        return Button(action: action) {
            HStack(spacing: Spacing.l) {
                Image(systemName: "book")
                Text(title)
                    .appStyle(.bodyMedium, weight: .semibold)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "chevron.right")
            }
            .foregroundStyle(Palette.onPrimaryContainer)
            .padding(Self.padding)
            .background(RoundedRectangle(cornerRadius: CornerRadius.extraLarge).fill(Palette.primaryContainer))
        }
        .buttonStyle(.plain)
    }
}
