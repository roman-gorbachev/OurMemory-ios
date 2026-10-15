import SwiftUI

struct ScanCandidatesPanel: View {
    let data: VeteranScanUiData
    let onVeteranOpen: (String) -> Void

    var body: some View {
        return VStack(alignment: .leading, spacing: Spacing.m) {
            if !data.candidates.isEmpty {
                Text("matching_veterans")
                    .appStyle(.subheadline, weight: .semibold)
                    .foregroundStyle(Palette.onSurfaceVariant)
                ForEach(data.candidates) { veteran in
                    Button {
                        onVeteranOpen(veteran.id)
                    } label: {
                        VeteranRow(veteran: veteran)
                    }
                    .buttonStyle(.plain)
                }
            } else {
                Text(data.hasRecognizedText ? "no_matching_veterans_msg" : "point_camera_at_qr_or_name_msg")
                    .appStyle(.callout)
                    .foregroundStyle(Palette.onSurface)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(Spacing.xl)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: CornerRadius.card, style: .continuous))
        .padding(.horizontal, Spacing.screen)
        .padding(.bottom, Spacing.m)
        .animation(.default, value: data)
    }
}

#Preview {
    ScanCandidatesPanel(data: VeteranScanUiData(candidates: [], hasRecognizedText: false), onVeteranOpen: { _ in })
}
