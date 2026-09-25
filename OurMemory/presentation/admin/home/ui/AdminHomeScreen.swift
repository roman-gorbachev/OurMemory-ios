import SwiftUI

struct AdminHomeScreen: View {
    let data: AdminHomeUiData
    let onOpen: (AdminDestination) -> Void
    let onSignOut: () -> Void

    var body: some View {
        return ScrollView {
            VStack(alignment: .leading, spacing: Spacing.l) {
                AdminHeader(email: data.email, onSignOut: onSignOut)
                GroupTitle(text: "requires_attention")
                HStack(spacing: Spacing.l) {
                    StatTile(count: data.pendingSubmissionsCount, title: "pending_submissions", systemImage: "photo.badge.plus") {
                        onOpen(.moderation)
                    }
                    StatTile(count: data.newFeedbackCount, title: "new_requests", systemImage: "envelope") {
                        onOpen(.feedback)
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                GroupTitle(text: "content")
                HStack(spacing: Spacing.l) {
                    ContentTile(
                        title: "veterans",
                        subtitle: L10n.format("veteran_cards_count", data.veteransCount),
                        systemImage: "person"
                    ) { onOpen(.veterans) }
                    ContentTile(
                        title: "burial_places",
                        subtitle: L10n.format("burial_places_count", data.burialsCount),
                        systemImage: "building.columns"
                    ) { onOpen(.burials) }
                }
                .fixedSize(horizontal: false, vertical: true)
                HStack(spacing: Spacing.l) {
                    ContentTile(
                        title: "tours",
                        subtitle: L10n.format("routes_count", data.toursCount),
                        systemImage: "figure.walk"
                    ) { onOpen(.tours) }
                    ContentTile(
                        title: "editor_guide",
                        subtitle: L10n.string("how_to_add_and_edit_content_msg"),
                        systemImage: "book"
                    ) { onOpen(.guide(section: nil)) }
                }
                .fixedSize(horizontal: false, vertical: true)
            }
            .padding(Spacing.screen)
            .padding(.bottom, Spacing.tabBarInset)
        }
        .background(Palette.background.ignoresSafeArea())
    }
}

#Preview {
    AdminHomeScreen(data: AdminHomeUiData(email: "admin@memory.by", pendingSubmissionsCount: 2), onOpen: { _ in }, onSignOut: {})
}
