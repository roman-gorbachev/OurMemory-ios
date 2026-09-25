import SwiftUI
import VisionKit

struct QrScannerModifier: ViewModifier {
    @Binding var isPresented: Bool
    let onVeteranScanned: (String) -> Void
    @State private var alertMessage: LocalizedStringKey?

    func body(content: Content) -> some View {
        return content
            .onChange(of: isPresented) { _, presented in
                if presented && !(DataScannerViewController.isSupported && DataScannerViewController.isAvailable) {
                    isPresented = false
                    alertMessage = "failed_to_open_scanner_msg"
                }
            }
            .fullScreenCover(isPresented: $isPresented) {
                NavigationStack {
                    QrScannerView { payload in
                        isPresented = false
                        if let veteranId = VeteranLink.parseVeteranId(payload) {
                            onVeteranScanned(veteranId)
                        } else {
                            alertMessage = "not_our_qr_code_msg"
                        }
                    }
                    .ignoresSafeArea()
                    .navigationTitle("scan_qr_code")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("cancel") { isPresented = false }
                        }
                    }
                }
            }
            .alert(
                alertMessage ?? "",
                isPresented: Binding(get: { return alertMessage != nil }, set: { if !$0 { alertMessage = nil } })
            ) {
                Button("done", role: .cancel) {}
            }
    }
}

extension View {
    func qrScanner(isPresented: Binding<Bool>, onVeteranScanned: @escaping (String) -> Void) -> some View {
        return modifier(QrScannerModifier(isPresented: isPresented, onVeteranScanned: onVeteranScanned))
    }
}
