import SwiftUI

struct LocationSection: View {
    private static let mapHeight: CGFloat = 180
    private static let zoom: Float = 16

    let onOpenMap: () -> Void
    let onRoute: () -> Void

    var body: some View {
        return VStack(alignment: .leading, spacing: 0) {
            SectionTitle(text: "locationHeader")
            VStack(alignment: .leading, spacing: Spacing.l) {
                MapPreview(latitude: CemeteryLocation.latitude, longitude: CemeteryLocation.longitude, zoom: Self.zoom)
                    .frame(height: Self.mapHeight)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.large, style: .continuous))
                Label("address", systemImage: "mappin.and.ellipse")
                    .appStyle(.body)
                HStack(spacing: Spacing.m) {
                    Button(action: onOpenMap) {
                        Label("cemetery_map", systemImage: "map")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    Button(action: onRoute) {
                        Label("get_directions", systemImage: "arrow.triangle.turn.up.right.diamond")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                .controlSize(.large)
            }
            .cardBackground()
        }
    }
}
