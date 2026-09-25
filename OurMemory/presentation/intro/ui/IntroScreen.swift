import SwiftUI

struct IntroScreen: View {
    private static let heroHeightRatio: CGFloat = 0.4
    private static let fadeStart = 0.55

    let onStart: () -> Void

    var body: some View {
        return GeometryReader { proxy in
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: Spacing.xxl) {
                        hero(height: proxy.size.height * Self.heroHeightRatio + proxy.safeAreaInsets.top)
                        VStack(spacing: Spacing.m) {
                            Text("app_name")
                                .appStyle(.largeTitle, weight: .bold)
                                .fontDesign(.serif)
                            Text("slogan")
                                .appStyle(.body)
                                .foregroundStyle(Palette.onSurfaceVariant)
                        }
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, Spacing.xxl)
                        VStack(alignment: .leading, spacing: Spacing.xxl) {
                            IntroFeatureRow(systemImage: "person.text.rectangle", title: "heroes_biographies", subtitle: "heroes_biographies_msg")
                            IntroFeatureRow(systemImage: "figure.walk", title: "audio_tours_of_cemetery", subtitle: "audio_tours_of_cemetery_msg")
                            IntroFeatureRow(systemImage: "flame", title: "candle_and_favorites", subtitle: "candle_and_favorites_msg")
                        }
                        .padding(.horizontal, Spacing.xxxl)
                    }
                    .padding(.bottom, Spacing.xxl)
                }
                .ignoresSafeArea(edges: .top)
                .scrollBounceBehavior(.basedOnSize)
                Button(action: onStart) {
                    Text("start")
                        .appStyle(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.horizontal, Spacing.xxl)
                .padding(.vertical, Spacing.xl)
            }
        }
        .background(Palette.background.ignoresSafeArea())
    }

    private func hero(height: CGFloat) -> some View {
        return Color.clear
            .frame(height: height)
            .overlay {
                Image("splash")
                    .resizable()
                    .scaledToFill()
            }
            .clipped()
            .overlay {
                LinearGradient(
                    stops: [
                        .init(color: .clear, location: Self.fadeStart),
                        .init(color: Palette.background, location: 1)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
    }
}

#Preview {
    IntroScreen {}
}
