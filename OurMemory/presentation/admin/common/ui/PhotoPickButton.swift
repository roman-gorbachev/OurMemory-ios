import PhotosUI
import SwiftUI

struct PhotoPickButton: View {
    let title: LocalizedStringKey
    var systemImage = "photo.badge.plus"
    let onPicked: (Data) -> Void
    @State private var selection: PhotosPickerItem?

    var body: some View {
        return PhotosPicker(selection: $selection, matching: .images) {
            Label(title, systemImage: systemImage)
        }
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
