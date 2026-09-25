import SwiftUI

struct RewardsRow: View {
    private static let iconSize: CGFloat = 64

    let rewards: [RewardCount]
    @State private var selected: RewardCount?

    var body: some View {
        return VStack(alignment: .leading, spacing: 0) {
            SectionTitle(text: "awards")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.xl) {
                    ForEach(rewards, id: \.reward) { item in
                        Button {
                            selected = item
                        } label: {
                            Image(item.reward.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: Self.iconSize, height: Self.iconSize)
                                .overlay(alignment: .bottomTrailing) {
                                    if item.count > 1 {
                                        RewardTimes(count: item.count)
                                    }
                                }
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(item.reward.nameKey)
                    }
                }
            }
            .contentMargins(.horizontal, Spacing.screen, for: .scrollContent)
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
