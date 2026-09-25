import SwiftUI

struct MapControls: View {
    private static let size: CGFloat = 44

    let checkedWar: Bool
    let checkedArt: Bool
    let isSatellite: Bool
    let onWarChange: (Bool) -> Void
    let onArtChange: (Bool) -> Void
    let onMapTypeTap: () -> Void
    let onMyLocationTap: () -> Void

    var body: some View {
        return VStack(spacing: 0) {
            CategoryFilterMenu(checkedWar: checkedWar, checkedArt: checkedArt, onWarChange: onWarChange, onArtChange: onArtChange)
                .frame(width: Self.size, height: Self.size)
            Divider()
            Button(action: onMapTypeTap) {
                Image(systemName: isSatellite ? "map" : "globe.europe.africa")
                    .frame(width: Self.size, height: Self.size)
            }
            .accessibilityLabel(isSatellite ? "scheme" : "satellite")
            Divider()
            Button(action: onMyLocationTap) {
                Image(systemName: "location")
                    .frame(width: Self.size, height: Self.size)
            }
            .accessibilityLabel("my_location")
        }
        .font(.title3)
        .foregroundStyle(Palette.primary)
        .frame(width: Self.size)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: CornerRadius.large, style: .continuous))
        .shadow(color: Palette.shadow, radius: Shadow.largeRadius, y: Shadow.offsetY)
    }
}

#Preview {
    MapControls(
        checkedWar: true,
        checkedArt: true,
        isSatellite: false,
        onWarChange: { _ in },
        onArtChange: { _ in },
        onMapTypeTap: {},
        onMyLocationTap: {}
    )
    .padding()
    .background(Color.gray)
}
