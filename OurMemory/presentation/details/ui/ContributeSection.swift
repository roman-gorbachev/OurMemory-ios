import SwiftUI

struct ContributeSection: View {
    let onAddToHistory: () -> Void
    let onReportError: () -> Void

    var body: some View {
        return VStack(spacing: 0) {
            row(title: "add_to_history", systemImage: "square.and.pencil", action: onAddToHistory)
            Divider().padding(.leading, Spacing.xxxl + Spacing.xl)
            row(title: "report_an_error", systemImage: "exclamationmark.bubble", action: onReportError)
        }
        .background(RoundedRectangle(cornerRadius: CornerRadius.card, style: .continuous).fill(Palette.surface))
        .padding(.horizontal, Spacing.screen)
    }

    private func row(title: LocalizedStringKey, systemImage: String, action: @escaping () -> Void) -> some View {
        return Button(action: action) {
            HStack(spacing: Spacing.l) {
                Image(systemName: systemImage)
                    .foregroundStyle(Palette.primary)
                    .frame(width: Spacing.xxl)
                Text(title)
                    .foregroundStyle(Palette.onSurface)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "chevron.right")
                    .appStyle(.footnote, weight: .semibold)
                    .foregroundStyle(Palette.tertiaryLabel)
            }
            .padding(Spacing.xl)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContributeSection(onAddToHistory: {}, onReportError: {})
        .background(Palette.groupedBackground)
}
