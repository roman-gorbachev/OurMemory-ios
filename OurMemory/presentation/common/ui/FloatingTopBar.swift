import SwiftUI

private enum FloatingTopBarMetrics {
    static let titleHorizontalInset: CGFloat = 60
    static let dividerHeight: CGFloat = 0.5
}

struct FloatingTopBar<Trailing: View>: View {
    let title: String
    let isCollapsed: Bool
    let onBack: (() -> Void)?
    @ViewBuilder var trailing: () -> Trailing

    var body: some View {
        return VStack(spacing: 0) {
            ZStack {
                if let onBack {
                    CircleIconButton(systemImage: "chevron.left", accessibilityLabel: "back", action: onBack)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Text(verbatim: title)
                    .appStyle(.titleMedium, weight: .bold)
                    .foregroundStyle(Palette.onSurface)
                    .lineLimit(1)
                    .padding(.horizontal, FloatingTopBarMetrics.titleHorizontalInset)
                    .opacity(isCollapsed ? 1 : 0)
                HStack(spacing: Spacing.m) {
                    trailing()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, Spacing.l)
            .frame(height: Spacing.topBarHeight)
            Rectangle()
                .fill(Palette.outlineVariant)
                .frame(height: FloatingTopBarMetrics.dividerHeight)
                .opacity(isCollapsed ? 1 : 0)
        }
        .background {
            Palette.collapsedBar
                .opacity(isCollapsed ? 1 : 0)
                .ignoresSafeArea(edges: .top)
        }
        .animation(.easeInOut, value: isCollapsed)
    }
}

extension FloatingTopBar where Trailing == EmptyView {
    init(title: String, isCollapsed: Bool, onBack: (() -> Void)?) {
        self.init(title: title, isCollapsed: isCollapsed, onBack: onBack) {
            EmptyView()
        }
    }
}

#Preview {
    FloatingTopBar(title: "Ветеран", isCollapsed: true, onBack: {})
}
