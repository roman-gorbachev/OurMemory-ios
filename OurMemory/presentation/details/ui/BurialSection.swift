import SwiftUI

struct BurialSection: View {
    private static let mapHeight: CGFloat = 180
    private static let zoom: Float = 18

    let burial: BurialUi
    let onShowOnMap: () -> Void

    var body: some View {
        return VStack(alignment: .leading, spacing: 0) {
            SectionTitle(text: "burial_place")
            VStack(alignment: .leading, spacing: Spacing.l) {
                MapPreview(latitude: burial.latitude, longitude: burial.longitude, zoom: Self.zoom)
                    .frame(height: Self.mapHeight)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.large, style: .continuous))
                PlotNumberText(burial: burial)
                Button(action: onShowOnMap) {
                    Label("show_on_map", systemImage: "map")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
            .cardBackground()
        }
    }
}
