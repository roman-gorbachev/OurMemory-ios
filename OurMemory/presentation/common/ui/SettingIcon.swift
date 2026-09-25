import SwiftUI

struct SettingIcon: View {
    private static let size: CGFloat = 40
    private static let iconSize: CGFloat = 18

    let systemImage: String

    var body: some View {
        return Image(systemName: systemImage)
            .font(.system(size: Self.iconSize, weight: .medium))
            .foregroundStyle(Palette.primary)
            .frame(width: Self.size, height: Self.size)
            .background(Circle().fill(Palette.primaryContainer))
    }
}
