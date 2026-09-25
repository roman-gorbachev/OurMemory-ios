import SwiftUI

struct AdminBurialsRoute: View {
    @State private var viewModel: AdminBurialsViewModel
    let onBack: () -> Void
    let onOpen: (AdminDestination) -> Void

    init(viewModel: AdminBurialsViewModel, onBack: @escaping () -> Void, onOpen: @escaping (AdminDestination) -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onBack = onBack
        self.onOpen = onOpen
    }

    var body: some View {
        return TopBarContainer(title: L10n.string("burial_places"), onBack: onBack) {
            ZStack(alignment: .bottomTrailing) {
                switch viewModel.adminBurialsUiState {
                case .loading:
                    LoadingView()
                case .error:
                    ErrorView()
                case .success(let items):
                    list(items)
                }
                AdminAddButton(title: "add_burial_place") { onOpen(.burialEditor(burialId: "")) }
            }
        }
        .onAppear { Task { await viewModel.load() } }
    }

    private func list(_ items: [AdminBurialItemUi]) -> some View {
        return ScrollView {
            LazyVStack(spacing: Spacing.m) {
                GuideHintCard(title: "how_to_add_a_burial_place") { onOpen(.guide(section: .burial)) }
                ForEach(items) { item in
                    Button {
                        onOpen(.burialEditor(burialId: item.id))
                    } label: {
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text(item.type.titleKey)
                                .appStyle(.titleMedium, weight: .bold)
                                .foregroundStyle(Palette.primary)
                            PlotNumberText(burial: item.burial)
                            if !item.veteranNames.isBlank {
                                Text(verbatim: item.veteranNames)
                                    .appStyle(.bodyMedium)
                                    .foregroundStyle(Palette.onSurface)
                            }
                        }
                        .multilineTextAlignment(.leading)
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
}
