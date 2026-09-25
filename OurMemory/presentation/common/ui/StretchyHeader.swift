import SwiftUI

struct StretchyHeader<Background: View, Overlay: View>: View {
    let height: CGFloat
    @ViewBuilder var background: () -> Background
    @ViewBuilder var overlay: () -> Overlay

    var body: some View {
        return GeometryReader { proxy in
            let offset = proxy.frame(in: .global).minY
            let stretch = max(offset, 0)
            ZStack(alignment: .bottomLeading) {
                Palette.containerHighest
                background()
                HeroScrim()
                overlay()
            }
            .frame(width: proxy.size.width, height: height + stretch)
            .clipped()
            .offset(y: -stretch)
        }
        .frame(height: height)
    }
}
