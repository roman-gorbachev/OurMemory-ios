import SwiftUI

struct AdminVeteransRoute: View {
    private static let portraitSize: CGFloat = 40

    @State private var viewModel: AdminVeteransViewModel
    let onOpen: (AdminDestination) -> Void

    init(viewModel: AdminVeteransViewModel, onOpen: @escaping (AdminDestination) -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onOpen = onOpen
    }

    var body: some View {
        return content
            .navigationTitle("veterans")
            .searchable(text: $viewModel.search, prompt: Text("search_by_name"))
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        onOpen(.veteranEditor(veteranId: ""))
                    } label: {
                        Label("add_veteran", systemImage: "plus")
                    }
                }
            }
            .onAppear { Task { await viewModel.load() } }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.adminVeteransUiState {
        case .loading:
            LoadingView()
        case .error:
            ErrorView()
        case .success(let items):
            List {
                Section {
                    GuideLinkRow(title: "how_to_add_a_veteran") { onOpen(.guide(section: .veteran)) }
                }
                Section {
                    ForEach(items) { item in
                        DisclosureButton {
                            onOpen(.veteranEditor(veteranId: item.id))
                        } label: {
                            HStack(spacing: Spacing.l) {
                                PortraitImage(url: item.portrait)
                                    .frame(width: Self.portraitSize, height: Self.portraitSize)
                                    .clipShape(Circle())
                                VStack(alignment: .leading, spacing: Spacing.xxs) {
                                    Text(verbatim: item.name).appStyle(.headline)
                                    Text(verbatim: item.years)
                                        .appStyle(.subheadline)
                                        .foregroundStyle(Palette.onSurfaceVariant)
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
    }
}
