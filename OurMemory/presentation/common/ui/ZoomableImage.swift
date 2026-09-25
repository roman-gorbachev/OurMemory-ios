import SwiftUI

struct ZoomableImage: View {
    private static let minZoom: CGFloat = 1
    private static let maxZoom: CGFloat = 5
    private static let doubleTapZoom: CGFloat = 2.5

    let url: String
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1
    @State private var offset = CGSize.zero
    @State private var lastOffset = CGSize.zero

    var body: some View {
        return RemoteImage(url: url, placeholder: "imageInfoPlaceholder", contentMode: .fit)
            .scaleEffect(scale)
            .offset(offset)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .gesture(magnification.simultaneously(with: drag))
            .onTapGesture(count: 2) {
                withAnimation(.easeInOut) {
                    scale = scale > Self.minZoom ? Self.minZoom : Self.doubleTapZoom
                    lastScale = scale
                    offset = .zero
                    lastOffset = .zero
                }
            }
    }

    private var magnification: some Gesture {
        return MagnifyGesture()
            .onChanged { value in
                scale = min(max(lastScale * value.magnification, Self.minZoom), Self.maxZoom)
            }
            .onEnded { _ in
                lastScale = scale
                if scale <= Self.minZoom {
                    offset = .zero
                    lastOffset = .zero
                }
            }
    }

    private var drag: some Gesture {
        return DragGesture()
            .onChanged { value in
                guard scale > Self.minZoom else {
                    return
                }
                offset = CGSize(
                    width: lastOffset.width + value.translation.width,
                    height: lastOffset.height + value.translation.height
                )
            }
            .onEnded { _ in
                lastOffset = offset
            }
    }
}
