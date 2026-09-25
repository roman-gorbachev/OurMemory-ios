import SwiftUI

struct AdminToursRoute: View {
    @State private var viewModel: AdminToursViewModel
    let onBack: () -> Void
    let onOpen: (AdminDestination) -> Void

    init(viewModel: AdminToursViewModel, onBack: @escaping () -> Void, onOpen: @escaping (AdminDestination) -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onBack = onBack
        self.onOpen = onOpen
    }

    var body: some View {
        return TopBarContainer(title: L10n.string("tours"), onBack: onBack) {
            ZStack(alignment: .bottomTrailing) {
                switch viewModel.adminToursUiState {
                case .loading:
                    LoadingView()
                case .error:
                    ErrorView()
                case .success(let items):
                    ScrollView {
                        LazyVStack(spacing: Spacing.m) {
                            GuideHintCard(title: "how_to_build_a_tour") { onOpen(.guide(section: .tour)) }
                            ForEach(items) { item in
                                Button {
                                    onOpen(.tourEditor(tourId: item.id))
                                } label: {
                                    VStack(alignment: .leading, spacing: Spacing.xs) {
                                        Text(verbatim: item.title)
                                            .appStyle(.titleMedium, weight: .bold)
                                            .foregroundStyle(Palette.primary)
                                        Text(verbatim: L10n.format("stops_count", item.stopCount))
                                            .appStyle(.bodyMedium)
                                            .foregroundStyle(Palette.onSurfaceVariant)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(Spacing.l)
                                    .background(RoundedRectangle(cornerRadius: CornerRadius.card).fill(Palette.containerLow))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(Spacing.screen)
                        .padding(.bottom, Spacing.tabBarInset)
                    }
                }
                AdminAddButton(title: "add_tour") { onOpen(.tourEditor(tourId: "")) }
            }
        }
        .onAppear { Task { await viewModel.load() } }
    }
}
