import PhotosUI
import SwiftUI

struct PhotoPickButton: View {
    let title: LocalizedStringKey
    var kind = AppButtonKind.outlined
    let onPicked: (Data) -> Void
    @State private var selection: PhotosPickerItem?

    var body: some View {
        return PhotosPicker(selection: $selection, matching: .images) {
            Text(title)
        }
        .buttonStyle(AppButtonStyle(kind: kind))
        .onChange(of: selection) { _, item in
            guard let item else {
                return
            }
            selection = nil
            Task {
                if let data = try? await item.loadTransferable(type: Data.self) {
                    onPicked(data)
                }
            }
        }
    }
}
