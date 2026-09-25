import SwiftUI

struct FeedbackCard: View {
    let item: FeedbackItemUi
    let onVeteranOpen: (String) -> Void
    let onAction: (FeedbackListUserAction) -> Void
    @State private var reply = ""

    var body: some View {
        return VStack(alignment: .leading, spacing: Spacing.m) {
            HStack {
                Text(item.type.titleKey)
                    .appStyle(.caption, weight: .semibold)
                    .foregroundStyle(Palette.primary)
                Spacer()
                Text(verbatim: item.date)
                    .appStyle(.caption)
                    .foregroundStyle(Palette.onSurfaceVariant)
            }
            Text(verbatim: item.text)
                .appStyle(.body)
            if !item.contact.isBlank {
                Label { Text(verbatim: item.contact) } icon: { Image(systemName: "person.crop.circle") }
                    .appStyle(.subheadline)
                    .foregroundStyle(Palette.onSurfaceVariant)
                    .textSelection(.enabled)
            }
            if !item.veteranId.isBlank {
                Button {
                    onVeteranOpen(item.veteranId)
                } label: {
                    Label { Text(verbatim: item.veteranName.isBlank ? item.veteranId : item.veteranName) } icon: { Image(systemName: "person.text.rectangle") }
                        .appStyle(.subheadline)
                }
                .buttonStyle(.borderless)
            }
            if !item.reply.isBlank {
                Text(verbatim: L10n.format("your_reply", item.reply))
                    .appStyle(.callout)
                    .foregroundStyle(Palette.primary)
            } else {
                HStack(spacing: Spacing.m) {
                    TextField("reply", text: $reply, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                    Button {
                        onAction(.reply(feedbackId: item.id, text: reply))
                    } label: {
                        Image(systemName: "arrow.up.circle.fill").font(.title2)
                    }
                    .buttonStyle(.borderless)
                    .disabled(reply.isBlank)
                    .accessibilityLabel("send_reply")
                }
            }
            if item.isReviewed {
                Label("reviewed", systemImage: "checkmark.circle.fill")
                    .appStyle(.caption)
                    .foregroundStyle(Palette.success)
            }
        }
        .padding(.vertical, Spacing.xs)
    }
}
