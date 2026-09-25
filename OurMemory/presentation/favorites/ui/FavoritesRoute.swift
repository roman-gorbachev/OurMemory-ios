import SwiftUI

struct FavoritesRoute: View {
    private static let portraitSize: CGFloat = 44

    @State private var viewModel: FavoritesViewModel
    let onVeteranOpen: (String) -> Void

    init(viewModel: FavoritesViewModel, onVeteranOpen: @escaping (String) -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onVeteranOpen = onVeteranOpen
    }

    var body: some View {
        return content
            .navigationTitle("favorites")
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.favoritesUiState {
        case .loading:
            LoadingView()
        case .error:
            ErrorView()
        case .success(let items):
            List(items) { item in
                Button {
                    onVeteranOpen(item.id)
                } label: {
                    HStack(spacing: Spacing.l) {
                        PortraitImage(url: item.portrait)
                            .frame(width: Self.portraitSize, height: Self.portraitSize)
                            .clipShape(Circle())
                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                            Text(verbatim: item.name)
                                .appStyle(.headline)
                                .foregroundStyle(Palette.onSurface)
                            Text(verbatim: item.years)
                                .appStyle(.subheadline)
                                .foregroundStyle(Palette.onSurfaceVariant)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .overlay {
                if items.isEmpty {
                    ContentUnavailableView("favorites", systemImage: "heart", description: Text("no_favorites_yet_msg"))
                }
            }
        }
    }
}
