import SwiftUI

struct HeroScrim: View {
    private static let topEnd = 0.25
    private static let bottomStart = 0.5

    var body: some View {
        return LinearGradient(
            stops: [
                .init(color: Palette.scrimTop, location: 0),
                .init(color: .clear, location: Self.topEnd),
                .init(color: .clear, location: Self.bottomStart),
                .init(color: Palette.scrimBottom, location: 1)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

#Preview {
    HeroScrim()
}
