import SwiftUI

struct RewardTimes: View {
    let count: Int

    var body: some View {
        return Text(verbatim: L10n.format("times_count", count))
            .appStyle(.caption, weight: .bold)
            .foregroundStyle(Palette.white)
            .padding(.horizontal, Spacing.s)
            .padding(.vertical, Spacing.xxs)
            .background(Capsule().fill(Palette.primary))
    }
}
