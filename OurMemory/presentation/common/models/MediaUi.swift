import Foundation

struct MediaUi: Hashable, Identifiable {
    let url: String
    let description: String

    private static let assetScheme = "asset:"

    var id: String {
        return url + description
    }

    static func asset(_ name: String) -> MediaUi {
        return MediaUi(url: assetScheme + name, description: "")
    }

    static func assetName(from url: String) -> String? {
        guard url.hasPrefix(assetScheme) else {
            return nil
        }
        return String(url.dropFirst(assetScheme.count))
    }
}
