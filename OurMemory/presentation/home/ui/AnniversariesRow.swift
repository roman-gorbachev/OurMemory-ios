import SwiftUI

struct AnniversariesRow: View {
    private static let cardWidth: CGFloat = 240
    private static let portraitSize: CGFloat = 48
    private static let cardPadding: CGFloat = 10
    private static let nameLines = 2

    let anniversaries: [AnniversaryUi]
    let onVeteranOpen: (String) -> Void

    var body: some View {
        return VStack(alignment: .leading, spacing: 0) {
            Text("on_this_day")
                .appStyle(.titleMedium, weight: .bold)
                .foregroundStyle(Palette.primary)
                .padding(.horizontal, Spacing.screen)
                .padding(.vertical, Spacing.m)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.m) {
                    ForEach(anniversaries) { anniversary in
                        card(anniversary)
                    }
                }
                .padding(.horizontal, Spacing.screen)
            }
        }
    }

    private func card(_ anniversary: AnniversaryUi) -> some View {
        return Button {
            onVeteranOpen(anniversary.veteranId)
        } label: {
            HStack(spacing: Self.cardPadding) {
                PortraitImage(url: anniversary.portrait)
                    .frame(width: Self.portraitSize, height: Self.portraitSize)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(verbatim: anniversary.name)
                        .appStyle(.titleSmall, weight: .bold)
                        .lineLimit(Self.nameLines)
                    Text(verbatim: L10n.format(anniversary.isBirthday ? "birthday_in_year" : "day_of_memory_in_year", anniversary.year))
                        .appStyle(.bodySmall)
                }
                .foregroundStyle(Palette.onPrimaryContainer)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(Self.cardPadding)
            .frame(width: Self.cardWidth)
            .background(RoundedRectangle(cornerRadius: CornerRadius.extraLarge).fill(Palette.primaryContainer))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AnniversariesRow(
        anniversaries: [AnniversaryUi(veteranId: "1", name: "Иванов Иван", portrait: "", isBirthday: true, year: 1905)],
        onVeteranOpen: { _ in }
    )
}
