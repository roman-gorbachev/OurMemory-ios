import SwiftUI

struct BurialSection: View {
    private static let mapHeight: CGFloat = 180
    private static let zoom: Float = 18

    let burial: BurialUi
    let onShowOnMap: () -> Void

    var body: some View {
        return VStack(alignment: .leading, spacing: 0) {
            SectionTitle(text: "burial_place")
            PlotNumberText(burial: burial)
                .padding(.horizontal, Spacing.screen)
                .padding(.bottom, Spacing.l)
            MapPreview(latitude: burial.latitude, longitude: burial.longitude, zoom: Self.zoom)
                .frame(height: Self.mapHeight)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.extraLarge))
                .padding(.horizontal, Spacing.screen)
            AppButton(title: "show_on_map", systemImage: "map", kind: .outlined, action: onShowOnMap)
                .padding(.horizontal, Spacing.screen)
                .padding(.top, Spacing.l)
        }
    }
}
