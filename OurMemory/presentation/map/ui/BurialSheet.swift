import SwiftUI

struct BurialSheet: View {
    private static let photoMaxHeight: CGFloat = 240
    private static let portraitSize: CGFloat = 56

    let details: BurialDetailsUi
    let onVeteranOpen: (String) -> Void

    var body: some View {
        return ScrollView {
            VStack(alignment: .leading, spacing: Spacing.l) {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(details.type.titleKey)
                        .appStyle(.titleLarge, weight: .bold)
                        .foregroundStyle(Palette.primary)
                    PlotNumberText(burial: details.burial)
                }
                if !details.photo.isBlank {
                    RemoteImage(url: details.photo)
                        .frame(maxWidth: .infinity)
                        .frame(height: Self.photoMaxHeight)
                        .background(Palette.containerHigh)
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.extraLarge))
                }
                if !details.description.isBlank {
                    Text(verbatim: details.description)
                        .appStyle(.bodyLarge)
                        .foregroundStyle(Palette.onSurface)
                }
                ForEach(details.veterans) { veteran in
                    veteranRow(veteran)
                }
            }
            .padding(.horizontal, Spacing.xxl)
            .padding(.top, Spacing.xxl)
            .padding(.bottom, Spacing.xxxl)
        }
    }

    private func veteranRow(_ veteran: VeteranShortUi) -> some View {
        return Button {
            onVeteranOpen(veteran.id)
        } label: {
            HStack(spacing: Spacing.l) {
                PortraitImage(url: veteran.portrait)
                    .frame(width: Self.portraitSize, height: Self.portraitSize)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(verbatim: veteran.name)
                        .appStyle(.titleMedium, weight: .bold)
                        .foregroundStyle(Palette.onSurface)
                    if !veteran.years.isBlank {
                        Text(verbatim: veteran.years)
                            .appStyle(.bodyMedium)
                            .foregroundStyle(Palette.onSurfaceVariant)
                    }
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
    BurialSheet(
        details: BurialDetailsUi(
            burial: BurialUi(id: "1", latitude: 0, longitude: 0, section: "1", row: "2", place: "3"),
            type: .grave,
            photo: "",
            description: "Описание",
            veterans: [VeteranShortUi(id: "1", name: "Иванов Иван", years: "1905–1966", portrait: "")]
        ),
        onVeteranOpen: { _ in }
    )
}
