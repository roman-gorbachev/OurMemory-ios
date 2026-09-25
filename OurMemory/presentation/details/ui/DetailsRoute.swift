import SwiftUI

struct DetailsRoute: View {
    @State private var viewModel: DetailsViewModel
    let onBack: () -> Void
    let onShowOnMap: (String) -> Void
    let onAddToHistory: () -> Void
    let onReportError: () -> Void

    init(
        viewModel: DetailsViewModel,
        onBack: @escaping () -> Void,
        onShowOnMap: @escaping (String) -> Void,
        onAddToHistory: @escaping () -> Void,
        onReportError: @escaping () -> Void
    ) {
        _viewModel = State(initialValue: viewModel)
        self.onBack = onBack
        self.onShowOnMap = onShowOnMap
        self.onAddToHistory = onAddToHistory
        self.onReportError = onReportError
    }

    var body: some View {
        return content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Palette.background.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .task { await viewModel.load() }
            .task(id: isLoaded) {
                guard isLoaded, viewModel.shouldAskNotifications else {
                    return
                }
                _ = await ReminderNotifications.requestAuthorization()
                viewModel.onAction(.notificationsAsked)
            }
    }

    private var isLoaded: Bool {
        if case .success = viewModel.detailsUiState {
            return true
        }
        return false
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.detailsUiState {
        case .loading:
            LoadingView()
                .safeAreaInset(edge: .top) { FloatingTopBar(title: "", isCollapsed: false, onBack: onBack) }
        case .error:
            ErrorView()
                .safeAreaInset(edge: .top) { FloatingTopBar(title: "", isCollapsed: false, onBack: onBack) }
        case .success(let data):
            DetailsScreen(
                data: data,
                playbackState: viewModel.playbackState,
                candleState: viewModel.candleState,
                isFavorite: viewModel.isFavorite,
                onAction: viewModel.onAction,
                onBack: onBack,
                onShowOnMap: onShowOnMap,
                onAddToHistory: onAddToHistory,
                onReportError: onReportError
            )
        }
    }
}
