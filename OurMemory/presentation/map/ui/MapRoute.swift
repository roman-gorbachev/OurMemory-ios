import SwiftUI

struct MapRoute: View {
    @State private var viewModel: MapViewModel
    let onBack: (() -> Void)?
    let onVeteranOpen: (String) -> Void
    let onTourOpen: (String) -> Void

    init(
        viewModel: MapViewModel,
        onBack: (() -> Void)?,
        onVeteranOpen: @escaping (String) -> Void,
        onTourOpen: @escaping (String) -> Void
    ) {
        _viewModel = State(initialValue: viewModel)
        self.onBack = onBack
        self.onVeteranOpen = onVeteranOpen
        self.onTourOpen = onTourOpen
    }

    var body: some View {
        return content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Palette.background.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .task { await viewModel.load() }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.mapUiState {
        case .loading:
            LoadingView().overlay(alignment: .topLeading) { backButton }
        case .error:
            ErrorView().overlay(alignment: .topLeading) { backButton }
        case .success(let data):
            MapScreen(
                data: data,
                initialCamera: viewModel.initialCamera,
                bottomInset: onBack == nil ? Spacing.tabBarInset : 0,
                onAction: viewModel.onAction,
                onBack: onBack,
                onVeteranOpen: onVeteranOpen,
                onTourOpen: onTourOpen
            )
        }
    }

    @ViewBuilder
    private var backButton: some View {
        if let onBack {
            CircleIconButton(systemImage: "chevron.left", accessibilityLabel: "back", action: onBack)
                .padding(.horizontal, Spacing.l)
        }
    }
}
