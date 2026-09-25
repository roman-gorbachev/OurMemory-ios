import SwiftUI

struct AdminToursRoute: View {
    @State private var viewModel: AdminToursViewModel
    let onOpen: (AdminDestination) -> Void

    init(viewModel: AdminToursViewModel, onOpen: @escaping (AdminDestination) -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onOpen = onOpen
    }

    var body: some View {
        return content
            .navigationTitle("tours")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        onOpen(.tourEditor(tourId: ""))
                    } label: {
                        Label("add_tour", systemImage: "plus")
                    }
                }
            }
            .onAppear { Task { await viewModel.load() } }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.adminToursUiState {
        case .loading:
            LoadingView()
        case .error:
            ErrorView()
        case .success(let items):
            List {
                Section {
                    GuideLinkRow(title: "how_to_build_a_tour") { onOpen(.guide(section: .tour)) }
                }
                Section {
                    ForEach(items) { item in
                        DisclosureButton {
                            onOpen(.tourEditor(tourId: item.id))
                        } label: {
                            VStack(alignment: .leading, spacing: Spacing.xxs) {
                                Text(verbatim: item.title).appStyle(.headline)
                                Text(verbatim: L10n.format("stops_count", item.stopCount))
                                    .appStyle(.subheadline)
                                    .foregroundStyle(Palette.onSurfaceVariant)
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
    }
}
