import SwiftUI
import VisionKit

struct VeteranScannerView: UIViewControllerRepresentable {
    private static let textLanguages = ["ru-RU"]
    private static let lineSeparator = "\n"

    let onQrScanned: (String) -> Void
    let onTextRecognized: (String) -> Void

    func makeUIViewController(context: Context) -> DataScannerViewController {
        let controller = DataScannerViewController(
            recognizedDataTypes: [.barcode(symbologies: [.qr]), .text(languages: Self.textLanguages)],
            qualityLevel: .accurate,
            isHighlightingEnabled: true
        )
        controller.delegate = context.coordinator
        try? controller.startScanning()
        return controller
    }

    func updateUIViewController(_ controller: DataScannerViewController, context: Context) {}

    static func dismantleUIViewController(_ controller: DataScannerViewController, coordinator: Coordinator) {
        controller.stopScanning()
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(onQrScanned: onQrScanned, onTextRecognized: onTextRecognized)
    }

    final class Coordinator: NSObject, DataScannerViewControllerDelegate {
        private let onQrScanned: (String) -> Void
        private let onTextRecognized: (String) -> Void
        private var hasScannedQr = false
        private var lastText = ""

        init(onQrScanned: @escaping (String) -> Void, onTextRecognized: @escaping (String) -> Void) {
            self.onQrScanned = onQrScanned
            self.onTextRecognized = onTextRecognized
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            handle(allItems)
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didUpdate updatedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            handle(allItems)
        }

        private func handle(_ items: [RecognizedItem]) {
            guard !hasScannedQr else {
                return
            }
            for item in items {
                if case .barcode(let barcode) = item, let payload = barcode.payloadStringValue {
                    hasScannedQr = true
                    onQrScanned(payload)
                    return
                }
            }
            let text = items.compactMap { item -> String? in
                if case .text(let text) = item {
                    return text.transcript
                }
                return nil
            }.joined(separator: VeteranScannerView.lineSeparator)
            guard text != lastText else {
                return
            }
            lastText = text
            onTextRecognized(text)
        }
    }
}
