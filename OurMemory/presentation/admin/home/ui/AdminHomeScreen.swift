import SwiftUI

struct AdminHomeScreen: View {
    let data: AdminHomeUiData
    let onOpen: (AdminDestination) -> Void

    var body: some View {
        return List {
            Section {
                Label {
                    Text(verbatim: L10n.format("signed_in_as", data.email))
                        .appStyle(.subheadline)
                } icon: {
                    Image(systemName: "person.crop.circle.fill")
                        .foregroundStyle(Palette.primary)
                }
            }
            Section("requires_attention") {
                DisclosureRow(title: "pending_submissions", systemImage: "photo.on.rectangle.angled", color: .orange) {
                    onOpen(.moderation)
                } trailing: {
                    attentionValue(data.pendingSubmissionsCount)
                }
                DisclosureRow(title: "new_requests", systemImage: "envelope.fill", color: .blue) {
                    onOpen(.feedback)
                } trailing: {
                    attentionValue(data.newFeedbackCount)
                }
            }
            Section("content") {
                DisclosureRow(title: "veterans", systemImage: "person.2.fill", color: Palette.primary) {
                    onOpen(.veterans)
                } trailing: {
                    countText(data.veteransCount)
                }
                DisclosureRow(title: "burial_places", systemImage: "building.columns.fill", color: .brown) {
                    onOpen(.burials)
                } trailing: {
                    countText(data.burialsCount)
                }
                DisclosureRow(title: "tours", systemImage: "figure.walk", color: .green) {
                    onOpen(.tours)
                } trailing: {
                    countText(data.toursCount)
                }
            }
            Section {
                GuideLinkRow(title: "editor_guide") { onOpen(.guide(section: nil)) }
            } footer: {
                Text("how_to_add_and_edit_content_msg")
            }
        }
        .listStyle(.insetGrouped)
    }

    @ViewBuilder
    private func attentionValue(_ count: Int) -> some View {
        if count > 0 {
            CountBadge(count: count)
        } else {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(Palette.success)
                .accessibilityLabel("everything_is_reviewed_msg")
        }
    }

    private func countText(_ count: Int) -> some View {
        return Text(verbatim: String(count))
            .foregroundStyle(Palette.onSurfaceVariant)
            .monospacedDigit()
    }
}

#Preview {
    NavigationStack {
        AdminHomeScreen(data: AdminHomeUiData(email: "admin@memory.by", pendingSubmissionsCount: 2), onOpen: { _ in })
            .navigationTitle("administration")
    }
}
