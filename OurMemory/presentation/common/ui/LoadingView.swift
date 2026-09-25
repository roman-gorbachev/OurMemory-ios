import SwiftUI

struct LoadingView: View {
    var body: some View {
        return ProgressView()
            .tint(Palette.primary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    LoadingView()
}
