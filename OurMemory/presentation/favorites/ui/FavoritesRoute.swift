import SwiftUI

struct FavoritesRoute: View {
    @State private var viewModel: FavoritesViewModel
    let onBack: () -> Void
    let onVeteranOpen: (String) -> Void

    init(viewModel: FavoritesViewModel, onBack: @escaping () -> Void, onVeteranOpen: @escaping (String) -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onBack = onBack
        self.onVeteranOpen = onVeteranOpen
    }

    var body: some View {
        return TopBarContainer(title: L10n.string("favorites"), onBack: onBack) {
            switch viewModel.favoritesUiState {
            case .loading:
                LoadingView()
            case .error:
                ErrorView()
            case .success(let items):
                FavoritesScreen(items: items, onVeteranOpen: onVeteranOpen)
            }
        }
    }
}
