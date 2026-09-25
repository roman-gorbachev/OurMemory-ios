import SwiftUI

struct ChevronIcon: View {
    var body: some View {
        return Image(systemName: "chevron.right")
            .font(.footnote.weight(.semibold))
            .foregroundStyle(Palette.onSurfaceVariant)
    }
}
