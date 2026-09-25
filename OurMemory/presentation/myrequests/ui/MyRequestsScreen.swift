import SwiftUI

struct MyRequestsScreen: View {
    let items: [MyRequestItemUi]

    var body: some View {
        return ScrollView {
            LazyVStack(alignment: .leading, spacing: Spacing.l) {
                if items.isEmpty {
                    Text("no_requests_yet_msg")
                        .appStyle(.bodyLarge)
                        .foregroundStyle(Palette.onSurfaceVariant)
                        .padding(.top, Spacing.xl)
                }
                ForEach(items) { item in
                    MyRequestCard(item: item)
                }
            }
            .padding(Spacing.screen)
        }
    }
}

#Preview {
    MyRequestsScreen(items: [
        MyRequestItemUi(requestId: "1", kind: .feedback, veteranName: "Иванов", text: "Текст", status: .reviewed, reply: "Спасибо", date: "01.05.2026 10:00")
    ])
}
