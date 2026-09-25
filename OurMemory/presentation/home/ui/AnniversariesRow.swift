import SwiftUI

struct AnniversariesRow: View {
    private static let cardWidth: CGFloat = 250
    private static let portraitSize: CGFloat = 44
    private static let nameLines = 2

    let anniversaries: [AnniversaryUi]
    let onVeteranOpen: (String) -> Void

    var body: some View {
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.m) {
                ForEach(anniversaries) { anniversary in
                    Button {
                        onVeteranOpen(anniversary.veteranId)
                    } label: {
                        card(anniversary)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .contentMargins(.horizontal, Spacing.xl, for: .scrollContent)
    }

    private func card(_ anniversary: AnniversaryUi) -> some View {
        return HStack(spacing: Spacing.l) {
            PortraitImage(url: anniversary.portrait)
                .frame(width: Self.portraitSize, height: Self.portraitSize)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(verbatim: anniversary.name)
                    .appStyle(.subheadline, weight: .semibold)
                    .foregroundStyle(Palette.onSurface)
                    .lineLimit(Self.nameLines)
                Label {
                    Text(verbatim: L10n.format(anniversary.isBirthday ? "birthday_in_year" : "day_of_memory_in_year", anniversary.year))
                } icon: {
                    Image(systemName: anniversary.isBirthday ? "gift" : "flame")
                }
                .appStyle(.caption)
                .foregroundStyle(Palette.primary)
            }
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(Spacing.l)
        .frame(width: Self.cardWidth)
        .background(RoundedRectangle(cornerRadius: CornerRadius.large).fill(Palette.surface))
    }
}
