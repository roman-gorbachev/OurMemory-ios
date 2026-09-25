import SwiftUI

struct LocationSection: View {
    private static let mapHeight: CGFloat = 180
    private static let zoom: Float = 16

    let onOpenMap: () -> Void
    let onRoute: () -> Void

    var body: some View {
        return VStack(alignment: .leading, spacing: 0) {
            SectionTitle(text: "locationHeader")
            Text("address")
                .appStyle(.bodyLarge)
                .foregroundStyle(Palette.onSurface)
                .padding(.horizontal, Spacing.screen)
                .padding(.bottom, Spacing.l)
            MapPreview(latitude: CemeteryLocation.latitude, longitude: CemeteryLocation.longitude, zoom: Self.zoom)
                .frame(height: Self.mapHeight)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.extraLarge))
                .padding(.horizontal, Spacing.screen)
            VStack(spacing: Spacing.m) {
                AppButton(title: "cemetery_map", systemImage: "map", action: onOpenMap)
                AppButton(title: "get_directions", systemImage: "location", kind: .outlined, action: onRoute)
            }
            .padding(.horizontal, Spacing.screen)
            .padding(.top, Spacing.l)
        }
    }
}
