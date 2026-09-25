import SwiftUI

struct EmptyListText: View {
    var body: some View {
        return Text("nothing_here_yet")
            .appStyle(.bodyLarge)
            .foregroundStyle(Palette.onSurfaceVariant)
            .padding(.top, Spacing.xl)
    }
}
