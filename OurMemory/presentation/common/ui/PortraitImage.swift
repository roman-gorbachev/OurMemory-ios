import NukeUI
import SwiftUI

struct PortraitImage: View {
    private static let symbolScale: CGFloat = 0.45

    let url: String

    var body: some View {
        return LazyImage(url: URL(string: url)) { state in
            if let image = state.image {
                image.resizable().aspectRatio(contentMode: .fill)
            } else {
                GeometryReader { proxy in
                    let side = min(proxy.size.width, proxy.size.height) * Self.symbolScale
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Palette.onSurfaceVariant)
                        .frame(width: side, height: side)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Palette.containerHighest)
                }
            }
        }
    }
}

#Preview {
    PortraitImage(url: "")
        .frame(width: 80, height: 100)
}
