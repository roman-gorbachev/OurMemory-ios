import SwiftUI

struct IntroScreen: View {
    private static let blurRadius: CGFloat = 8
    private static let dimOpacity = 0.5
    private static let titleSize: CGFloat = 38
    private static let titleTracking: CGFloat = 4
    private static let bodySize: CGFloat = 20
    private static let buttonTitleSize: CGFloat = 18
    private static let buttonWidth: CGFloat = 220
    private static let buttonHeight: CGFloat = 70
    private static let largeGap: CGFloat = 60
    private static let mediumGap: CGFloat = 36
    private static let contentPadding: CGFloat = 30

    let onStart: () -> Void

    var body: some View {
        return ZStack {
            Image("splash")
                .resizable()
                .scaledToFill()
                .blur(radius: Self.blurRadius)
                .ignoresSafeArea()
            Palette.black.opacity(Self.dimOpacity).ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    Text("app_name")
                        .font(Typography.custom(size: Self.titleSize, weight: .bold, relativeTo: .largeTitle))
                        .tracking(Self.titleTracking)
                        .multilineTextAlignment(.center)
                    Spacer().frame(height: Self.largeGap)
                    Text("slogan")
                        .font(Typography.custom(size: Self.bodySize, weight: .medium, relativeTo: .title3))
                        .multilineTextAlignment(.center)
                    Spacer().frame(height: Self.mediumGap)
                    ImageSlideshow(images: CemeteryPhotos.all)
                    Spacer().frame(height: Self.mediumGap)
                    Text("idea")
                        .font(Typography.custom(size: Self.bodySize, weight: .regular, relativeTo: .title3))
                        .multilineTextAlignment(.center)
                    Spacer().frame(height: Self.largeGap)
                    startButton
                }
                .foregroundStyle(Palette.white)
                .padding(Self.contentPadding)
                .frame(maxWidth: .infinity)
            }
            .scrollBounceBehavior(.basedOnSize)
            .defaultScrollAnchor(.center)
        }
    }

    private var startButton: some View {
        return Button(action: onStart) {
            HStack {
                Text("start")
                    .font(Typography.custom(size: Self.buttonTitleSize, weight: .medium, relativeTo: .headline))
                Spacer()
                Image(systemName: "chevron.right")
            }
            .foregroundStyle(Palette.white)
            .padding(.horizontal, Spacing.xxl)
            .frame(width: Self.buttonWidth, height: Self.buttonHeight)
            .background(RoundedRectangle(cornerRadius: CornerRadius.large).fill(Palette.brandRed))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    IntroScreen {}
}
