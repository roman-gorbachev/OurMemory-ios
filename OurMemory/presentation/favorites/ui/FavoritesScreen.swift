import SwiftUI

struct FavoritesScreen: View {
    private static let portraitSize: CGFloat = 48

    let items: [FavoriteVeteranUi]
    let onVeteranOpen: (String) -> Void

    var body: some View {
        return ScrollView {
            LazyVStack(alignment: .leading, spacing: Spacing.m) {
                if items.isEmpty {
                    Text("no_favorites_yet_msg")
                        .appStyle(.bodyLarge)
                        .foregroundStyle(Palette.onSurfaceVariant)
                        .padding(.top, Spacing.xl)
                }
                ForEach(items) { item in
                    Button {
                        onVeteranOpen(item.id)
                    } label: {
                        HStack(spacing: Spacing.l) {
                            PortraitImage(url: item.portrait)
                                .frame(width: Self.portraitSize, height: Self.portraitSize)
                                .clipShape(Circle())
                            VStack(alignment: .leading, spacing: Spacing.xxs) {
                                Text(verbatim: item.name)
                                    .appStyle(.titleMedium, weight: .bold)
                                    .foregroundStyle(Palette.onSurface)
                                Text(verbatim: item.years)
                                    .appStyle(.bodySmall)
                                    .foregroundStyle(Palette.onSurfaceVariant)
                            }
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(Spacing.l)
                        .background(RoundedRectangle(cornerRadius: CornerRadius.large).fill(Palette.containerLow))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(Spacing.screen)
        }
    }
}

#Preview {
    FavoritesScreen(items: [FavoriteVeteranUi(id: "1", name: "Иванов Иван", years: "1905–1966", portrait: "")]) { _ in }
}
