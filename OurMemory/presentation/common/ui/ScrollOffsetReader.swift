import SwiftUI

struct ScrollOffsetReader: View {
    let coordinateSpace: String
    let onChange: (CGFloat) -> Void

    var body: some View {
        return GeometryReader { proxy in
            Color.clear
                .onChange(of: proxy.frame(in: .named(coordinateSpace)).minY, initial: true) { _, value in
                    onChange(value)
                }
        }
        .frame(height: 0)
    }
}
