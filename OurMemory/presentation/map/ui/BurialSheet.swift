import SwiftUI

struct BurialSheet: View {
    private static let photoHeight: CGFloat = 200
    private static let portraitSize: CGFloat = 44

    let details: BurialDetailsUi
    let onVeteranOpen: (String) -> Void

    var body: some View {
        return NavigationStack {
            List {
                if !details.photo.isBlank || !details.description.isBlank {
                    Section {
                        if !details.photo.isBlank {
                            RemoteImage(url: details.photo)
                                .frame(height: Self.photoHeight)
                                .clipped()
                                .listRowInsets(EdgeInsets())
                        }
                        if !details.description.isBlank {
                            Text(verbatim: details.description)
                                .appStyle(.body)
                        }
                    }
                }
                if !details.veterans.isEmpty {
                    Section("veterans") {
                        ForEach(details.veterans) { veteran in
                            Button {
                                onVeteranOpen(veteran.id)
                            } label: {
                                HStack(spacing: Spacing.l) {
                                    PortraitImage(url: veteran.portrait)
                                        .frame(width: Self.portraitSize, height: Self.portraitSize)
                                        .clipShape(Circle())
                                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                                        Text(verbatim: veteran.name)
                                            .appStyle(.headline)
                                            .foregroundStyle(Palette.onSurface)
                                        if !veteran.years.isBlank {
                                            Text(verbatim: veteran.years)
                                                .appStyle(.subheadline)
                                                .foregroundStyle(Palette.onSurfaceVariant)
                                        }
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .appStyle(.footnote, weight: .semibold)
                                        .foregroundStyle(Palette.tertiaryLabel)
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle(details.type.titleKey)
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .top, spacing: 0) {
                if details.burial.hasPlotNumber {
                    PlotNumberText(burial: details.burial)
                        .appStyle(.subheadline)
                        .foregroundStyle(Palette.onSurfaceVariant)
                        .padding(.bottom, Spacing.s)
                }
            }
        }
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
