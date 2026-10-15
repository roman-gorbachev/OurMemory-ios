import Foundation
import UIKit

nonisolated final class PhotoDownloader: @unchecked Sendable {
    private static let maxSide: CGFloat = 1600
    private static let jpegQuality: CGFloat = 0.85
    private static let originalScale: CGFloat = 1

    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func scaledJpegs(from urls: [String]) async -> [Data] {
        var photos: [Data] = []
        for url in urls {
            guard let url = URL(string: url),
                  let (data, _) = try? await session.data(from: url),
                  let jpeg = Self.scaledJpeg(data) else {
                continue
            }
            photos.append(jpeg)
        }
        return photos
    }

    private static func scaledJpeg(_ data: Data) -> Data? {
        guard let image = UIImage(data: data) else {
            return nil
        }
        let scale = min(originalScale, maxSide / max(image.size.width, image.size.height))
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let format = UIGraphicsImageRendererFormat()
        format.scale = originalScale
        let scaled = UIGraphicsImageRenderer(size: size, format: format).image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        return scaled.jpegData(compressionQuality: jpegQuality)
    }
}
