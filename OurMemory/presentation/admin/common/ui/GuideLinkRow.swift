import SwiftUI

struct GuideLinkRow: View {
    let title: LocalizedStringKey
    let action: () -> Void

    var body: some View {
        return DisclosureRow(title: title, systemImage: "book.fill", color: .orange, action: action)
    }
}
