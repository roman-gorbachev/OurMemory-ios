import SwiftUI
import UniformTypeIdentifiers

struct AudioPickButton: View {
    let onPicked: (URL) -> Void
    @State private var isImporterPresented = false

    var body: some View {
        return AppButton(title: "add_audio", kind: .outlined) {
            isImporterPresented = true
        }
        .fixedSize()
        .fileImporter(isPresented: $isImporterPresented, allowedContentTypes: [.audio]) { result in
            if case .success(let url) = result, let copy = try? AudioFileCopier.temporaryCopy(of: url) {
                onPicked(copy)
            }
        }
    }
}
