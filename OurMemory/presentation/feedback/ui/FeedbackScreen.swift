import SwiftUI

struct FeedbackScreen: View {
    private static let messageMinLines = 5

    let data: FeedbackUiData
    let onAction: (FeedbackUserAction) -> Void

    var body: some View {
        let isEditable = data.status != .sending
        return ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                if !data.veteranName.isBlank {
                    Text(verbatim: data.veteranName)
                        .appStyle(.titleLarge, weight: .bold)
                        .foregroundStyle(Palette.primary)
                        .padding(.horizontal, Spacing.screen)
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.m) {
                        ForEach(FeedbackType.allCases, id: \.self) { type in
                            FilterToggle(title: type.titleKey, isSelected: type == data.type) {
                                onAction(.typeChanged(type))
                            }
                        }
                    }
                    .padding(.horizontal, Spacing.screen)
                    .padding(.vertical, Spacing.xs)
                }
                .disabled(!isEditable)
                VStack(spacing: Spacing.xl) {
                    AppTextField(
                        label: "message",
                        text: Binding(get: { return data.text }, set: { onAction(.textChanged($0)) }),
                        axis: .vertical,
                        minLines: Self.messageMinLines,
                        isError: data.hasTextProfanity,
                        supportingText: data.hasTextProfanity ? "remove_offensive_words_msg" : nil
                    )
                    AppTextField(
                        label: "contact_for_reply",
                        text: Binding(get: { return data.contact }, set: { onAction(.contactChanged($0)) }),
                        isError: data.hasContactProfanity,
                        supportingText: data.hasContactProfanity ? "remove_offensive_words_msg" : nil
                    )
                }
                .disabled(!isEditable)
                .padding(.horizontal, Spacing.screen)
                if data.status == .failed {
                    Text("failed_to_send_msg")
                        .appStyle(.bodyMedium)
                        .foregroundStyle(Palette.error)
                        .padding(.horizontal, Spacing.screen)
                }
                AppButton(title: "send", isLoading: data.status == .sending) { onAction(.send) }
                    .disabled(!data.canSend)
                    .padding(.horizontal, Spacing.screen)
            }
            .padding(.vertical, Spacing.xl)
        }
        .scrollDismissesKeyboard(.interactively)
    }
}

#Preview {
    FeedbackScreen(data: FeedbackUiData(), onAction: { _ in })
}
