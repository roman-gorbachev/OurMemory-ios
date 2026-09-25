import SwiftUI

struct SentView: View {
    let message: LocalizedStringKey
    let onDone: () -> Void

    var body: some View {
        return ContentUnavailableView {
            Label {
                Text(message)
            } icon: {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(Palette.success)
                    .symbolEffect(.bounce, value: true)
            }
        } actions: {
            Button("done", action: onDone)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
        }
    }
}

#Preview {
    SentView(message: "thank_you_message_sent_msg") {}
}
