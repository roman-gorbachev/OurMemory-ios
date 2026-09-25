import Foundation
import UIKit

nonisolated enum PhotoCompressor {
    private static let maxSidePixels = 2048
    private static let jpegQuality = 0.85
    private static let pixelScale = 1.0

    static func compress(_ imageData: Data) throws -> Data {
        guard let image = UIImage(data: imageData), let cgImage = image.cgImage else {
            throw PhotoCompressionError.unreadableImage
        }
        let orientedWidth = Int(image.size.width * image.scale)
        let orientedHeight = Int(image.size.height * image.scale)
        let target = ScaledSize.fitting(width: orientedWidth, height: orientedHeight, maxSide: maxSidePixels)
        let format = UIGraphicsImageRendererFormat()
        format.scale = pixelScale
        format.opaque = true
        let size = CGSize(width: target.width, height: target.height)
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        let resized = renderer.image { _ in
            UIImage(cgImage: cgImage, scale: pixelScale, orientation: image.imageOrientation)
                .draw(in: CGRect(origin: .zero, size: size))
        }
        guard let jpeg = resized.jpegData(compressionQuality: jpegQuality) else {
            throw PhotoCompressionError.encodingFailed
        }
        return jpeg
    }
}
