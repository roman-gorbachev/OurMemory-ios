import SwiftUI

struct ToursSheet: View {
    private static let descriptionLines = 2

    let tours: [TourSummaryUi]
    let onTourOpen: (String) -> Void

    var body: some View {
        return NavigationStack {
            List(tours) { tour in
                Button {
                    onTourOpen(tour.id)
                } label: {
                    HStack(spacing: Spacing.l) {
                        Image(systemName: "figure.walk.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(Palette.primary)
                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                            Text(verbatim: tour.title)
                                .appStyle(.headline)
                                .foregroundStyle(Palette.onSurface)
                            if !tour.description.isBlank {
                                Text(verbatim: tour.description)
                                    .appStyle(.subheadline)
                                    .foregroundStyle(Palette.onSurfaceVariant)
                                    .lineLimit(Self.descriptionLines)
                            }
                            Text(verbatim: tour.visitedCount > 0
                                ? L10n.format("visited_of_total", tour.visitedCount, tour.stopsCount)
                                : L10n.format("stops_count", tour.stopsCount))
                                .appStyle(.caption, weight: .semibold)
                                .foregroundStyle(Palette.primary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .appStyle(.footnote, weight: .semibold)
                            .foregroundStyle(Palette.tertiaryLabel)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("tours")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ToursSheet(tours: [TourSummaryUi(id: "1", title: "Герои", description: "Маршрут", stopsCount: 5)]) { _ in }
}
