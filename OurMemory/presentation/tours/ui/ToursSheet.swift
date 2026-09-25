import SwiftUI

struct ToursSheet: View {
    let tours: [TourSummaryUi]
    let onTourOpen: (String) -> Void

    var body: some View {
        return ScrollView {
            VStack(alignment: .leading, spacing: Spacing.m) {
                Text("tours")
                    .appStyle(.titleLarge, weight: .bold)
                    .foregroundStyle(Palette.primary)
                    .padding(.bottom, Spacing.m)
                ForEach(tours) { tour in
                    row(tour)
                }
            }
            .padding(.horizontal, Spacing.xxl)
            .padding(.top, Spacing.xxl)
            .padding(.bottom, Spacing.xxxl)
        }
    }

    private func row(_ tour: TourSummaryUi) -> some View {
        return Button {
            onTourOpen(tour.id)
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(verbatim: tour.title)
                        .appStyle(.titleMedium, weight: .bold)
                        .foregroundStyle(Palette.onSurface)
                    if !tour.description.isBlank {
                        Text(verbatim: tour.description)
                            .appStyle(.bodyMedium)
                            .foregroundStyle(Palette.onSurfaceVariant)
                    }
                    Text(verbatim: tour.visitedCount > 0
                        ? L10n.format("visited_of_total", tour.visitedCount, tour.stopsCount)
                        : L10n.format("stops_count", tour.stopsCount))
                        .appStyle(.labelMedium)
                        .foregroundStyle(Palette.primary)
                        .padding(.top, Spacing.xs)
                }
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "chevron.right")
                    .foregroundStyle(Palette.primary)
            }
            .padding(Spacing.l)
            .background(RoundedRectangle(cornerRadius: CornerRadius.extraLarge).fill(Palette.container))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ToursSheet(tours: [TourSummaryUi(id: "1", title: "Герои", description: "Маршрут", stopsCount: 5)]) { _ in }
}
