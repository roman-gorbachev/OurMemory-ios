import SwiftUI

struct MapControls: View {
    private static let size: CGFloat = 44

    let isSatellite: Bool
    let onMapTypeTap: () -> Void
    let onMyLocationTap: () -> Void

    var body: some View {
        return VStack(spacing: Spacing.l) {
            control(systemImage: "square.3.layers.3d", label: isSatellite ? "scheme" : "satellite", action: onMapTypeTap)
            control(systemImage: "location", label: "my_location", action: onMyLocationTap)
        }
    }

    private func control(systemImage: String, label: LocalizedStringKey, action: @escaping () -> Void) -> some View {
        return Button(action: action) {
            Image(systemName: systemImage)
                .font(.title3)
                .foregroundStyle(Palette.primary)
                .frame(width: Self.size, height: Self.size)
                .background(RoundedRectangle(cornerRadius: CornerRadius.large).fill(Palette.surface))
                .shadow(color: Palette.shadow, radius: Shadow.mediumRadius, y: Shadow.offsetY)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }
}

#Preview {
    MapControls(isSatellite: false, onMapTypeTap: {}, onMyLocationTap: {})
}
