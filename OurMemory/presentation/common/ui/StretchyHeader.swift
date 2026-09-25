import SwiftUI

struct StretchyHeader<Background: View, Overlay: View>: View {
    let height: CGFloat
    @ViewBuilder var background: () -> Background
    @ViewBuilder var overlay: () -> Overlay

    var body: some View {
        return GeometryReader { proxy in
            let stretch = max(proxy.frame(in: .global).minY, 0)
            let width = proxy.size.width
            Color.clear
                .frame(width: width, height: height + stretch)
                .overlay {
                    background()
                        .frame(width: width, height: height + stretch)
                        .clipped()
                }
                .overlay { HeroScrim() }
                .overlay(alignment: .bottomLeading) {
                    overlay()
                        .frame(width: width, alignment: .leading)
                }
                .background(Palette.containerHighest)
                .clipped()
                .offset(y: -stretch)
        }
        .frame(height: height)
    }
}
