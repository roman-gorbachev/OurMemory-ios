import SwiftUI

struct RewardsRow: View {
    private static let iconSize: CGFloat = 64

    let rewards: [RewardCount]
    @State private var selected: RewardCount?

    var body: some View {
        return VStack(alignment: .leading, spacing: 0) {
            SectionTitle(text: "awards")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.l) {
                    ForEach(rewards, id: \.reward) { item in
                        Button {
                            selected = item
                        } label: {
                            HStack(spacing: Spacing.xs) {
                                Image(item.reward.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: Self.iconSize, height: Self.iconSize)
                                if item.count > 1 {
                                    RewardTimes(count: item.count)
                                        .padding(.horizontal, Spacing.xs)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(item.reward.nameKey)
                    }
                }
                .padding(.horizontal, Spacing.screen)
            }
        }
        .sheet(item: $selected) { item in
            RewardSheet(item: item)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}

extension RewardCount: Identifiable {
    var id: Int {
        return reward.rawValue
    }
}

#Preview {
    RewardsRow(rewards: [RewardCount(reward: .redStar, count: 2), RewardCount(reward: .lenin, count: 1)])
}
