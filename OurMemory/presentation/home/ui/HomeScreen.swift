import SwiftUI

struct HomeScreen: View {
    let data: HomeUiData
    let onAction: (HomeUserAction) -> Void
    let onVeteranOpen: (String) -> Void

    var body: some View {
        return List {
            if !data.anniversaries.isEmpty && !data.veterans.isEmpty {
                Section("on_this_day") {
                    AnniversariesRow(anniversaries: data.anniversaries, onVeteranOpen: onVeteranOpen)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }
            }
            Section {
                ForEach(data.veterans) { veteran in
                    Button {
                        onVeteranOpen(veteran.id)
                    } label: {
                        VeteranRow(veteran: veteran)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .listStyle(.insetGrouped)
        .searchable(
            text: Binding(get: { return data.search }, set: { onAction(.searchChanged($0)) }),
            prompt: Text("search_by_name")
        )
        .overlay {
            if data.veterans.isEmpty {
                if data.checkedWar || data.checkedArt {
                    ContentUnavailableView.search(text: data.search)
                } else {
                    ContentUnavailableView("chooseCategory", systemImage: "line.3.horizontal.decrease.circle")
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                CategoryFilterMenu(
                    checkedWar: data.checkedWar,
                    checkedArt: data.checkedArt,
                    onWarChange: { onAction(.warToggled($0)) },
                    onArtChange: { onAction(.artToggled($0)) }
                )
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeScreen(
            data: HomeUiData(veterans: [
                VeteranItemUi(id: "1", name: "Иванов Иван Иванович", years: "1905–1966", baseInfo: "Герой Советского Союза", portrait: "")
            ]),
            onAction: { _ in },
            onVeteranOpen: { _ in }
        )
    }
}
