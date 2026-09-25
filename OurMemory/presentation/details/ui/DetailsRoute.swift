import SwiftUI

struct DetailsRoute: View {
    @State private var viewModel: DetailsViewModel
    let onShowOnMap: (String) -> Void
    let onAddToHistory: () -> Void
    let onReportError: () -> Void

    init(
        viewModel: DetailsViewModel,
        onShowOnMap: @escaping (String) -> Void,
        onAddToHistory: @escaping () -> Void,
        onReportError: @escaping () -> Void
    ) {
        _viewModel = State(initialValue: viewModel)
        self.onShowOnMap = onShowOnMap
        self.onAddToHistory = onAddToHistory
        self.onReportError = onReportError
    }

    var body: some View {
        return content
            .background(Palette.groupedBackground.ignoresSafeArea())
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
        case .error:
            ErrorView()
        case .success(let data):
            DetailsScreen(
                data: data,
                playbackState: viewModel.playbackState,
                candleState: viewModel.candleState,
                isFavorite: viewModel.isFavorite,
                onAction: viewModel.onAction,
                onShowOnMap: onShowOnMap,
                onAddToHistory: onAddToHistory,
                onReportError: onReportError
            )
        }
    }
}
