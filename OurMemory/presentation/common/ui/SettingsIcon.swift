import SwiftUI

struct SettingsIcon: View {
    private static let size: CGFloat = 29
    private static let cornerRadius: CGFloat = 7

    let systemImage: String
    var color = Palette.primary

    var body: some View {
        return Image(systemName: systemImage)
            .appStyle(.subheadline, weight: .semibold)
            .foregroundStyle(Palette.white)
            .frame(width: Self.size, height: Self.size)
            .background(RoundedRectangle(cornerRadius: Self.cornerRadius, style: .continuous).fill(color))
    }
}
