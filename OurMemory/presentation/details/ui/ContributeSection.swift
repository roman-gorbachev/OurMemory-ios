import SwiftUI

struct ContributeSection: View {
    let onAddToHistory: () -> Void
    let onReportError: () -> Void

    var body: some View {
        return VStack(spacing: Spacing.xs) {
            AppButton(title: "add_to_history", kind: .outlined, action: onAddToHistory)
            AppButton(title: "report_an_error", kind: .text, action: onReportError)
        }
        .padding(.horizontal, Spacing.screen)
    }
}

#Preview {
    ContributeSection(onAddToHistory: {}, onReportError: {})
}
