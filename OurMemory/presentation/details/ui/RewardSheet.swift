import SwiftUI

struct RewardSheet: View {
    private static let imageSize: CGFloat = 180

    let item: RewardCount

    var body: some View {
        return VStack(spacing: Spacing.xl) {
            Image(item.reward.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: Self.imageSize, height: Self.imageSize)
            Text(item.reward.nameKey)
                .appStyle(.title2, weight: .bold)
                .multilineTextAlignment(.center)
            if item.count > 1 {
                RewardTimes(count: item.count)
            }
        }
        .padding(.horizontal, Spacing.xxl)
        .padding(.vertical, Spacing.xxxl)
    }
}

#Preview {
    RewardSheet(item: RewardCount(reward: .heroUssr, count: 1))
}
