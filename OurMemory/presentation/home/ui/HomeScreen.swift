import SwiftUI

struct HomeScreen: View {
    private static let emptyMessagePadding: CGFloat = 64

    let data: HomeUiData
    let onAction: (HomeUserAction) -> Void
    let onVeteranOpen: (String) -> Void
    let onScanTap: () -> Void

    var body: some View {
        return ScrollView {
            LazyVStack(spacing: 0) {
                header
                if data.veterans.isEmpty {
                    Text("chooseCategory")
                        .appStyle(.titleMedium)
                        .foregroundStyle(Palette.onSurfaceVariant)
                        .padding(.vertical, Self.emptyMessagePadding)
                }
                if !data.veterans.isEmpty && !data.anniversaries.isEmpty {
                    AnniversariesRow(anniversaries: data.anniversaries, onVeteranOpen: onVeteranOpen)
                        .padding(.top, Spacing.xs)
                        .padding(.bottom, Spacing.m)
                }
                ForEach(data.veterans) { veteran in
                    VeteranRow(veteran: veteran) { onVeteranOpen(veteran.id) }
                }
            }
            .padding(.bottom, Spacing.xl + Spacing.tabBarInset)
        }
        .scrollDismissesKeyboard(.immediately)
    }

    private var header: some View {
        return VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("app_name")
                    .appStyle(.headlineMedium, weight: .bold)
                    .foregroundStyle(Palette.onSurface)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button(action: onScanTap) {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.title2)
                        .foregroundStyle(Palette.primary)
                }
                .accessibilityLabel("scan_qr_code")
            }
            .padding(.horizontal, Spacing.screen)
            .padding(.vertical, Spacing.l)
            SearchField(text: Binding(get: { return data.search }, set: { onAction(.searchChanged($0)) }))
                .padding(.horizontal, Spacing.screen)
            CategoryFilter(
                checkedWar: data.checkedWar,
                checkedArt: data.checkedArt,
                onWarChange: { onAction(.warToggled($0)) },
                onArtChange: { onAction(.artToggled($0)) }
            )
            .padding(.vertical, Spacing.m)
        }
    }
}

#Preview {
    HomeScreen(
        data: HomeUiData(veterans: [
            VeteranItemUi(id: "1", name: "Иванов Иван Иванович", years: "1905–1966", baseInfo: "Герой Советского Союза", portrait: "")
        ]),
        onAction: { _ in },
        onVeteranOpen: { _ in },
        onScanTap: {}
    )
}
