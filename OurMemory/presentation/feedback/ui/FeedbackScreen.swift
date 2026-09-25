import SwiftUI

struct FeedbackScreen: View {
    private static let messageMinLines = 5

    let data: FeedbackUiData
    let onAction: (FeedbackUserAction) -> Void

    var body: some View {
        return Form {
            if !data.veteranName.isBlank {
                Section {
                    Text(verbatim: data.veteranName)
                        .appStyle(.headline)
                }
            }
            Section {
                Picker("feedback", selection: Binding(get: { return data.type }, set: { onAction(.typeChanged($0)) })) {
                    ForEach(FeedbackType.allCases, id: \.self) { Text($0.titleKey).tag($0) }
                }
                .pickerStyle(.segmented)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            }
            Section {
                TextField("message", text: Binding(get: { return data.text }, set: { onAction(.textChanged($0)) }), axis: .vertical)
                    .lineLimit(Self.messageMinLines...)
            } footer: {
                if data.hasTextProfanity {
                    Text("remove_offensive_words_msg").foregroundStyle(Palette.error)
                }
            }
            Section {
                TextField("contact_for_reply", text: Binding(get: { return data.contact }, set: { onAction(.contactChanged($0)) }))
            } footer: {
                if data.hasContactProfanity {
                    Text("remove_offensive_words_msg").foregroundStyle(Palette.error)
                } else if data.status == .failed {
                    Text("failed_to_send_msg").foregroundStyle(Palette.error)
                }
            }
        }
        .disabled(data.status == .sending)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                if data.status == .sending {
                    ProgressView()
                } else {
                    Button("send") { onAction(.send) }
                        .disabled(!data.canSend)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        FeedbackScreen(data: FeedbackUiData(), onAction: { _ in })
    }
}
