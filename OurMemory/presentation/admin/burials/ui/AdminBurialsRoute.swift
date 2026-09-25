import SwiftUI

struct AdminBurialsRoute: View {
    @State private var viewModel: AdminBurialsViewModel
    let onOpen: (AdminDestination) -> Void

    init(viewModel: AdminBurialsViewModel, onOpen: @escaping (AdminDestination) -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onOpen = onOpen
    }

    var body: some View {
        return content
            .navigationTitle("burial_places")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        onOpen(.burialEditor(burialId: ""))
                    } label: {
                        Label("add_burial_place", systemImage: "plus")
                    }
                }
            }
            .onAppear { Task { await viewModel.load() } }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.adminBurialsUiState {
        case .loading:
            LoadingView()
        case .error:
            ErrorView()
        case .success(let items):
            List {
                Section {
                    GuideLinkRow(title: "how_to_add_a_burial_place") { onOpen(.guide(section: .burial)) }
                }
                Section {
                    ForEach(items) { item in
                        DisclosureButton {
                            onOpen(.burialEditor(burialId: item.id))
                        } label: {
                            VStack(alignment: .leading, spacing: Spacing.xxs) {
                                Text(item.type.titleKey).appStyle(.headline)
                                PlotNumberText(burial: item.burial)
                                    .appStyle(.subheadline)
                                    .foregroundStyle(Palette.onSurfaceVariant)
                                if !item.veteranNames.isBlank {
                                    Text(verbatim: item.veteranNames)
                                        .appStyle(.footnote)
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
