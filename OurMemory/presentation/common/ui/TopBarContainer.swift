import SwiftUI

struct TopBarContainer<Content: View, Trailing: View>: View {
    let title: String
    let onBack: () -> Void
    @ViewBuilder var trailing: () -> Trailing
    @ViewBuilder var content: () -> Content

    var body: some View {
        return content()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .safeAreaInset(edge: .top, spacing: 0) {
                FloatingTopBar(title: title, isCollapsed: true, onBack: onBack, trailing: trailing)
            }
            .background(Palette.background.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
    }
}

extension TopBarContainer where Trailing == EmptyView {
    init(title: String, onBack: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.init(title: title, onBack: onBack, trailing: { EmptyView() }, content: content)
    }
}

#Preview {
    TopBarContainer(title: "Избранное", onBack: {}) {
        Text(verbatim: "Content")
    }
}
