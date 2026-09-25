import SwiftUI

struct AppButton: View {
    let title: LocalizedStringKey
    var systemImage: String?
    var kind = AppButtonKind.filled
    var isLoading = false
    let action: () -> Void

    var body: some View {
        return Button(action: action) {
            HStack(spacing: Spacing.m) {
                if isLoading {
                    ProgressView()
                        .tint(kind == .filled ? Palette.onPrimary : Palette.primary)
                } else if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
            }
        }
        .buttonStyle(AppButtonStyle(kind: kind))
    }
}

#Preview {
    VStack {
        AppButton(title: "send") {}
        AppButton(title: "cancel", kind: .outlined) {}
    }
    .padding()
}
