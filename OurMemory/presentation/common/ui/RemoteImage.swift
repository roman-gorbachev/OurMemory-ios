import NukeUI
import SwiftUI

struct RemoteImage: View {
    let url: String
    var placeholder = "imageInfoPlaceholder"
    var contentMode = ContentMode.fill

    var body: some View {
        if let assetName = MediaUi.assetName(from: url) {
            return AnyView(Image(assetName).resizable().aspectRatio(contentMode: contentMode))
        }
        return AnyView(remote)
    }

    private var remote: some View {
        return LazyImage(url: URL(string: url)) { state in
            if let image = state.image {
                image.resizable().aspectRatio(contentMode: contentMode)
            } else {
                Image(placeholder).resizable().aspectRatio(contentMode: .fill)
            }
        }
    }
}

#Preview {
    RemoteImage(url: "")
        .frame(width: 120, height: 150)
}
