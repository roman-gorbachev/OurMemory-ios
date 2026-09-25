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
                    .appStyle(.labelLarge, weight: .bold)
                    .foregroundStyle(Palette.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(verbatim: item.date)
                    .appStyle(.labelMedium)
                    .foregroundStyle(Palette.onSurfaceVariant)
            }
            Text(verbatim: item.text)
                .appStyle(.bodyLarge)
                .foregroundStyle(Palette.onSurface)
            if !item.contact.isBlank {
                Text(verbatim: item.contact)
                    .appStyle(.bodyMedium)
                    .foregroundStyle(Palette.onSurfaceVariant)
                    .textSelection(.enabled)
            }
            replySection
            HStack {
                if !item.veteranId.isBlank {
                    Button {
                        onVeteranOpen(item.veteranId)
                    } label: {
                        Text(verbatim: item.veteranName.isBlank ? item.veteranId : item.veteranName)
                            .appStyle(.labelLarge, weight: .semibold)
                            .foregroundStyle(Palette.primary)
                            .lineLimit(1)
                    }
                }
                Spacer()
                if item.isReviewed {
                    Text("reviewed")
                        .appStyle(.labelLarge)
                        .foregroundStyle(Palette.onSurfaceVariant)
                } else {
                    AppButton(title: "mark_as_reviewed", kind: .outlined) {
                        onAction(.markReviewed(feedbackId: item.id))
                    }
                    .fixedSize()
                }
            }
        }
        .padding(Spacing.xl)
        .background(RoundedRectangle(cornerRadius: CornerRadius.large).fill(item.isReviewed ? Palette.surfaceVariant : Palette.surface))
        .shadow(color: item.isReviewed ? .clear : Palette.shadow, radius: Shadow.smallRadius, y: Shadow.offsetY)
    }

    @ViewBuilder
    private var replySection: some View {
        if !item.reply.isBlank {
            Text(verbatim: L10n.format("your_reply", item.reply))
                .appStyle(.bodyMedium)
                .foregroundStyle(Palette.primary)
        } else {
            AppTextField(label: "reply", text: $reply, axis: .vertical)
            if !reply.isBlank {
                AppButton(title: "send_reply") {
                    onAction(.reply(feedbackId: item.id, text: reply))
                }
            }
        }
    }
}
