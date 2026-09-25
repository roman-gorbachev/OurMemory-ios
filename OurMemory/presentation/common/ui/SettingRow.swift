import SwiftUI

private enum SettingRowMetrics {
    static let horizontalPadding: CGFloat = 14
}

struct SettingRow<Trailing: View>: View {
    let systemImage: String
    let title: LocalizedStringKey
    var subtitle: LocalizedStringKey?
    let action: () -> Void
    @ViewBuilder var trailing: () -> Trailing

    var body: some View {
        return Button(action: action) {
            HStack(spacing: Spacing.l) {
                SettingIcon(systemImage: systemImage)
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(title)
                        .appStyle(.titleMedium)
                        .foregroundStyle(Palette.onSurface)
                    if let subtitle {
                        Text(subtitle)
                            .appStyle(.bodySmall)
                            .foregroundStyle(Palette.onSurfaceVariant)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                trailing()
            }
            .padding(.horizontal, SettingRowMetrics.horizontalPadding)
            .padding(.vertical, Spacing.l)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

extension SettingRow where Trailing == ChevronIcon {
    init(systemImage: String, title: LocalizedStringKey, subtitle: LocalizedStringKey? = nil, action: @escaping () -> Void) {
        self.init(systemImage: systemImage, title: title, subtitle: subtitle, action: action) {
            ChevronIcon()
        }
    }
}

#Preview {
    SettingRow(systemImage: "qrcode.viewfinder", title: "scan_qr_code") {}
}
