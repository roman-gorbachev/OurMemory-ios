import SwiftUI

struct ImageSlideshow: View {
    private static let intervalSeconds = 4.0
    private static let height: CGFloat = 150
    private static let fadeSeconds = 0.6

    let images: [String]
    @State private var index = 0

    var body: some View {
        return ZStack {
            ForEach(Array(images.enumerated()), id: \.offset) { offset, name in
                if offset == index {
                    Image(name)
                        .resizable()
                        .scaledToFill()
                        .transition(.opacity)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: Self.height)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.extraLarge, style: .continuous))
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(Self.intervalSeconds))
                guard !images.isEmpty else {
                    return
                }
                withAnimation(.easeInOut(duration: Self.fadeSeconds)) {
                    index = (index + 1) % images.count
                }
            }
        }
    }
}
