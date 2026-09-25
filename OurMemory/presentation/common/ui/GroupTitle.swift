import SwiftUI

struct GroupTitle: View {
    let text: LocalizedStringKey

    var body: some View {
        return Text(text)
            .textCase(.uppercase)
            .appStyle(.labelMedium, weight: .bold)
            .foregroundStyle(Palette.onSurfaceVariant)
            .padding(.leading, Spacing.xs)
    }
}

#Preview {
    GroupTitle(text: "appearance")
}
