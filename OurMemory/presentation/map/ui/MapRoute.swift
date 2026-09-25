import SwiftUI

struct MapRoute: View {
    @State private var viewModel: MapViewModel
    let isRoot: Bool
    let onVeteranOpen: (String) -> Void
    let onTourOpen: (String) -> Void

    init(
        viewModel: MapViewModel,
        isRoot: Bool,
        onVeteranOpen: @escaping (String) -> Void,
        onTourOpen: @escaping (String) -> Void
    ) {
        _viewModel = State(initialValue: viewModel)
        self.isRoot = isRoot
        self.onVeteranOpen = onVeteranOpen
        self.onTourOpen = onTourOpen
    }

    var body: some View {
        return content
            .toolbar(isRoot ? .hidden : .visible, for: .navigationBar)
            .toolbarBackground(.hidden, for: .navigationBar)
            .task { await viewModel.load() }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.mapUiState {
        case .loading:
            LoadingView()
        case .error:
            ErrorView()
        case .success(let data):
            MapScreen(
                data: data,
                initialCamera: viewModel.initialCamera,
                onAction: viewModel.onAction,
                onVeteranOpen: onVeteranOpen,
                onTourOpen: onTourOpen
            )
        }
    }
}
