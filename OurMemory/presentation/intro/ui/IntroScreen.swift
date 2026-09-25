import SwiftUI

struct IntroScreen: View {
    private static let dimOpacity = 0.55
    private static let blurRadius: CGFloat = 6
    private static let ideaOpacity = 0.85

    let onStart: () -> Void

    var body: some View {
        return ZStack {
            Image("splash")
                .resizable()
                .scaledToFill()
                .blur(radius: Self.blurRadius)
                .ignoresSafeArea()
            Palette.black.opacity(Self.dimOpacity).ignoresSafeArea()
            VStack(spacing: Spacing.xxl) {
                Spacer()
                Image(systemName: "flame.fill")
                    .font(.system(.largeTitle))
                    .symbolEffect(.pulse)
                    .foregroundStyle(Palette.white)
                Text("app_name")
                    .appStyle(.largeTitle, weight: .bold)
                    .fontDesign(.serif)
                Text("slogan")
                    .appStyle(.title3)
                ImageSlideshow(images: CemeteryPhotos.all)
                Text("idea")
                    .appStyle(.body)
                    .foregroundStyle(Palette.white.opacity(Self.ideaOpacity))
                Spacer()
                Button(action: onStart) {
                    Text("start")
                        .appStyle(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .multilineTextAlignment(.center)
            .foregroundStyle(Palette.white)
            .padding(.horizontal, Spacing.xxl)
            .padding(.bottom, Spacing.xl)
        }
    }
}

#Preview {
    IntroScreen {}
}
