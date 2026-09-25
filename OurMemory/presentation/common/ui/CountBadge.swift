import SwiftUI

struct CountBadge: View {
    private static let minSize: CGFloat = 22

    let count: Int

    var body: some View {
        return Text(verbatim: String(count))
            .appStyle(.footnote, weight: .semibold)
            .foregroundStyle(Palette.white)
            .padding(.horizontal, Spacing.s)
            .frame(minWidth: Self.minSize, minHeight: Self.minSize)
            .background(Capsule().fill(Palette.error))
    }
}

#Preview {
    CountBadge(count: 3)
}
