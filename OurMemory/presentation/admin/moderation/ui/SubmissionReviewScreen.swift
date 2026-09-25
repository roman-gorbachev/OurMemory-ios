import SwiftUI

struct SubmissionReviewScreen: View {
    private static let textMinLines = 5
    private static let photoSize: CGFloat = 120
    private static let deselectedOpacity = 0.4

    let data: SubmissionReviewUiData
    let onAction: (SubmissionReviewUserAction) -> Void

    var body: some View {
        return Form {
            Section {
                LabeledContent("veteran") { Text(verbatim: data.veteranName) }
                LabeledContent("your_name_and_contact") {
                    Text(verbatim: data.contact).textSelection(.enabled)
                }
            } footer: {
                Text(verbatim: "\(data.date) · \(L10n.string(data.status.titleResource))")
            }
            Section("memories") {
                TextField("memories", text: Binding(get: { return data.text }, set: { onAction(.textChanged($0)) }), axis: .vertical)
                    .lineLimit(Self.textMinLines...)
            }
            if !data.photos.isEmpty {
                Section("add_to_card") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Spacing.m) {
                            ForEach(data.photos) { photo in
                                photoTile(photo)
                            }
                        }
                        .padding(.horizontal, Spacing.xl)
                    }
                    .listRowInsets(EdgeInsets(top: Spacing.l, leading: 0, bottom: Spacing.l, trailing: 0))
                }
            }
            Section {
                TextField("comment_for_author", text: Binding(get: { return data.reply }, set: { onAction(.replyChanged($0)) }), axis: .vertical)
            } footer: {
                if let failure = data.failure {
                    Text(failure.messageKey).foregroundStyle(Palette.error)
                }
            }
            Section {
                Button {
                    onAction(.approve)
                } label: {
                    Label("approve", systemImage: "checkmark.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                Button(role: .destructive) {
                    onAction(.reject)
                } label: {
                    Label("reject", systemImage: "xmark.circle")
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .disabled(!data.isEditable)
        .overlay {
            if data.isProcessing {
                ProgressView()
            }
        }
    }

    private func photoTile(_ photo: ReviewPhotoUi) -> some View {
        return Button {
            onAction(.photoToggled(photo.url))
        } label: {
            RemoteImage(url: photo.url)
                .frame(width: Self.photoSize, height: Self.photoSize)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.large, style: .continuous))
                .opacity(photo.isSelected ? 1 : Self.deselectedOpacity)
                .overlay(alignment: .topTrailing) {
                    Image(systemName: photo.isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Palette.white, photo.isSelected ? Palette.primary : Palette.dimmed)
                        .padding(Spacing.s)
                }
        }
        .buttonStyle(.plain)
    }
}
