import SwiftUI

struct VeteranScanScreen: View {
    let data: VeteranScanUiData
    let onQrScanned: (String) -> Void
    let onTextRecognized: (String) -> Void
    let onVeteranOpen: (String) -> Void

    var body: some View {
        return VeteranScannerView(onQrScanned: onQrScanned, onTextRecognized: onTextRecognized)
            .ignoresSafeArea()
            .safeAreaInset(edge: .bottom) {
                ScanCandidatesPanel(data: data, onVeteranOpen: onVeteranOpen)
            }
    }
}

#Preview {
    VeteranScanScreen(
        data: VeteranScanUiData(
            candidates: [VeteranItemUi(id: "1", name: "Иванов Иван", years: "1905–1966", baseInfo: "Описание", portrait: "")],
            hasRecognizedText: true
        ),
        onQrScanned: { _ in },
        onTextRecognized: { _ in },
        onVeteranOpen: { _ in }
    )
}
