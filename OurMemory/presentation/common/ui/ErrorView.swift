import SwiftUI

struct ErrorView: View {
    var message: LocalizedStringKey = "failed_to_load_data_msg"

    var body: some View {
        return Text(message)
            .appStyle(.body)
            .foregroundStyle(Palette.onSurfaceVariant)
            .multilineTextAlignment(.center)
            .padding(Spacing.xxxl)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ErrorView()
}
