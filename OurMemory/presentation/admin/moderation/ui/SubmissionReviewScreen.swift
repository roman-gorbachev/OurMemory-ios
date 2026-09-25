import SwiftUI

struct SubmissionReviewScreen: View {
    private static let textMinLines = 5
    private static let photoSize: CGFloat = 140
    private static let deselectedOpacity = 0.4

    let data: SubmissionReviewUiData
    let onAction: (SubmissionReviewUserAction) -> Void

    var body: some View {
        return ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xl) {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(verbatim: data.veteranName)
                        .appStyle(.titleLarge, weight: .bold)
                        .foregroundStyle(Palette.primary)
                    Text(verbatim: "\(data.date) · \(L10n.string(data.status.titleResource))")
                        .appStyle(.labelLarge)
                        .foregroundStyle(Palette.onSurfaceVariant)
                    Text(verbatim: data.contact)
                        .appStyle(.bodyMedium)
                        .foregroundStyle(Palette.onSurface)
                        .textSelection(.enabled)
                }
                .padding(.horizontal, Spacing.screen)
                VStack(spacing: Spacing.xl) {
                    AppTextField(
                        label: "memories",
                        text: Binding(get: { return data.text }, set: { onAction(.textChanged($0)) }),
                        axis: .vertical,
                        minLines: Self.textMinLines
                    )
                    AppTextField(
                        label: "comment_for_author",
                        text: Binding(get: { return data.reply }, set: { onAction(.replyChanged($0)) }),
                        axis: .vertical
                    )
                }
                .disabled(!data.isEditable)
                .padding(.horizontal, Spacing.screen)
                if !data.photos.isEmpty {
                    photos
                }
                if data.hasFailed {
                    Text("failed_to_save_msg")
                        .appStyle(.bodyMedium)
                        .foregroundStyle(Palette.error)
                        .padding(.horizontal, Spacing.screen)
                }
                HStack(spacing: Spacing.l) {
                    AppButton(title: "reject", kind: .outlined) { onAction(.reject) }
                    AppButton(title: "approve", isLoading: data.isProcessing) { onAction(.approve) }
                }
                .disabled(!data.isEditable)
                .padding(.horizontal, Spacing.screen)
            }
            .padding(.vertical, Spacing.xl)
        }
        .scrollDismissesKeyboard(.interactively)
    }

    private var photos: some View {
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.m) {
                ForEach(data.photos) { photo in
                    Button {
                        onAction(.photoToggled(photo.url))
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            RemoteImage(url: photo.url)
                                .frame(width: Self.photoSize, height: Self.photoSize)
                                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.large))
                                .opacity(photo.isSelected ? 1 : Self.deselectedOpacity)
                            Image(systemName: photo.isSelected ? "checkmark.square.fill" : "square")
                                .font(.title2)
                                .foregroundStyle(Palette.primary, Palette.white)
                                .padding(Spacing.s)
                        }
                    }
                    .buttonStyle(.plain)
                    .disabled(!data.isEditable)
                    .accessibilityLabel("add_to_card")
                }
            }
            .padding(.horizontal, Spacing.screen)
        }
    }
}
