import SwiftUI

struct RewardsEditor: View {
    private static let iconSize: CGFloat = 32
    private static let inactiveOpacity = 0.35

    let rewards: [Reward: Int]
    let onChange: (Reward, Int) -> Void

    var body: some View {
        return VStack(spacing: Spacing.m) {
            ForEach(Reward.allCases, id: \.self) { reward in
                let count = rewards[reward] ?? 0
                HStack(spacing: Spacing.m) {
                    Image(reward.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: Self.iconSize, height: Self.iconSize)
                        .opacity(count > 0 ? 1 : Self.inactiveOpacity)
                    Text(reward.nameKey)
                        .appStyle(.bodyMedium)
                        .foregroundStyle(Palette.onSurface)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button {
                        onChange(reward, -1)
                    } label: {
                        Image(systemName: "minus.circle")
                    }
                    .disabled(count == 0)
                    Text(verbatim: String(count))
                        .appStyle(.titleMedium, weight: .bold)
                        .monospacedDigit()
                    Button {
                        onChange(reward, 1)
                    } label: {
                        Image(systemName: "plus.circle")
                    }
                }
                .font(.title3)
                .foregroundStyle(Palette.primary)
            }
        }
    }
}
