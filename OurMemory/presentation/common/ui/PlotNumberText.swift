import SwiftUI

struct PlotNumberText: View {
    let burial: BurialUi

    var body: some View {
        if burial.hasPlotNumber {
            Text(verbatim: L10n.format("section_row_place_msg", burial.section, burial.row, burial.place))
                .appStyle(.bodyLarge)
                .foregroundStyle(Palette.onSurface)
        }
    }
}

#Preview {
    PlotNumberText(burial: BurialUi(id: "1", latitude: 0, longitude: 0, section: "3", row: "2", place: "7"))
}
