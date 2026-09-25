import SwiftUI

struct SentView: View {
    let message: LocalizedStringKey
    let onDone: () -> Void

    var body: some View {
        return VStack(spacing: Spacing.xxl) {
            Text(message)
                .appStyle(.titleLarge, weight: .bold)
                .foregroundStyle(Palette.onSurface)
                .multilineTextAlignment(.center)
            AppButton(title: "done", action: onDone)
                .fixedSize()
        }
        .padding(Spacing.xxxl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SentView(message: "thank_you_message_sent_msg") {}
}
