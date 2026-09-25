import SwiftUI

struct RewardTimes: View {
    let count: Int

    var body: some View {
        return Text(verbatim: L10n.format("times_count", count))
            .appStyle(.titleMedium, weight: .bold)
            .foregroundStyle(Palette.primary)
    }
}
