import SwiftUI
import UIKit

struct AdminsRoute: View {
    @State private var viewModel: AdminsViewModel
    @State private var isAddSheetPresented = false
    @State private var pendingRemoval: AdminItemUi?

    init(viewModel: AdminsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        return content
            .navigationTitle("administrators")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isAddSheetPresented = true
                    } label: {
                        Label("add_administrator", systemImage: "person.badge.plus")
                    }
                }
            }
            .sheet(isPresented: $isAddSheetPresented, onDismiss: { viewModel.onAction(.addStatusShown) }) {
                AddAdminSheet(status: viewModel.addStatus) { viewModel.onAction(.add(email: $0)) }
                    .presentationDetents([.medium])
            }
            .confirmationDialog(
                "remove_administrator_msg",
                isPresented: Binding(get: { return pendingRemoval != nil }, set: { if !$0 { pendingRemoval = nil } }),
                titleVisibility: .visible,
                presenting: pendingRemoval
            ) { item in
                Button("delete", role: .destructive) { viewModel.onAction(.remove(uid: item.uid)) }
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.adminsUiState {
        case .loading:
            LoadingView()
        case .error:
            ErrorView()
        case .success(let items):
            List {
                Section {
                    ForEach(items) { item in
                        row(item)
                            .swipeActions {
                                if item.canRemove {
                                    Button("delete", role: .destructive) { pendingRemoval = item }
                                }
                            }
                    }
                } footer: {
                    Text("add_uid_to_storage_rules_msg")
                }
            }
            .listStyle(.insetGrouped)
        }
    }

    private func row(_ item: AdminItemUi) -> some View {
        return VStack(alignment: .leading, spacing: Spacing.xxs) {
            HStack(spacing: Spacing.m) {
                Text(verbatim: item.email.isEmpty ? item.uid : item.email)
                    .appStyle(.headline)
                if item.isSuperAdmin {
                    Text("super_administrator")
                        .appStyle(.caption, weight: .semibold)
                        .foregroundStyle(Palette.primary)
                }
            }
            Text(verbatim: item.uid)
                .appStyle(.caption)
                .foregroundStyle(Palette.onSurfaceVariant)
                .textSelection(.enabled)
        }
        .contextMenu {
            Button {
                UIPasteboard.general.string = item.uid
            } label: {
                Label("copy_uid", systemImage: "doc.on.doc")
            }
        }
    }
}
