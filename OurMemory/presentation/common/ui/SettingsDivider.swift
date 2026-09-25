import SwiftUI

struct SettingsDivider: View {
    private static let leadingInset: CGFloat = 68
    private static let thickness: CGFloat = 0.5

    var body: some View {
        return Rectangle()
            .fill(Palette.outlineVariant)
            .frame(height: Self.thickness)
            .padding(.leading, Self.leadingInset)
    }
}
