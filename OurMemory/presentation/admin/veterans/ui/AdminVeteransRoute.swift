import SwiftUI

struct AdminVeteransRoute: View {
    private static let portraitSize: CGFloat = 48

    @State private var viewModel: AdminVeteransViewModel
    let onBack: () -> Void
    let onOpen: (AdminDestination) -> Void

    init(viewModel: AdminVeteransViewModel, onBack: @escaping () -> Void, onOpen: @escaping (AdminDestination) -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onBack = onBack
        self.onOpen = onOpen
    }

    var body: some View {
        return TopBarContainer(title: L10n.string("veterans"), onBack: onBack) {
            ZStack(alignment: .bottomTrailing) {
                switch viewModel.adminVeteransUiState {
                case .loading:
                    LoadingView()
                case .error:
                    ErrorView()
                case .success(let items):
                    list(items)
                }
                AdminAddButton(title: "add_veteran") { onOpen(.veteranEditor(veteranId: "")) }
            }
        }
        .onAppear { Task { await viewModel.load() } }
    }

    private func list(_ items: [AdminVeteranItemUi]) -> some View {
        return ScrollView {
            LazyVStack(spacing: Spacing.m) {
                GuideHintCard(title: "how_to_add_a_veteran") { onOpen(.guide(section: .veteran)) }
                AdminSearchField(placeholder: "search_by_name", text: $viewModel.search)
                ForEach(items) { item in
                    Button {
                        onOpen(.veteranEditor(veteranId: item.id))
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
