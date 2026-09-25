import UIKit

enum MapImages {
    private static let numberRadius: CGFloat = 20
    private static let numberStroke: CGFloat = 2
    private static let numberFontSize: CGFloat = 14
    private static let userDotOuterRadius: CGFloat = 11
    private static let userDotInnerRadius: CGFloat = 7.5
    private static let brandRed = UIColor(red: 0x7F / 255.0, green: 0x04 / 255.0, blue: 0x10 / 255.0, alpha: 1)
    private static var numberCache: [Int: UIImage] = [:]

    static var marker: UIImage {
        return UIImage(named: "icMarker") ?? UIImage()
    }

    static var accentColor: UIColor {
        return brandRed
    }

    static func number(_ number: Int) -> UIImage {
        if let cached = numberCache[number] {
            return cached
        }
        let diameter = numberRadius * 2
        let size = CGSize(width: diameter, height: diameter)
        let image = UIGraphicsImageRenderer(size: size).image { _ in
            let circle = UIBezierPath(ovalIn: CGRect(origin: .zero, size: size).insetBy(dx: numberStroke / 2, dy: numberStroke / 2))
            brandRed.setFill()
            circle.fill()
            UIColor.white.setStroke()
            circle.lineWidth = numberStroke
            circle.stroke()
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: numberFontSize),
                .foregroundColor: UIColor.white
            ]
            let text = String(number) as NSString
            let textSize = text.size(withAttributes: attributes)
            text.draw(
                at: CGPoint(x: (diameter - textSize.width) / 2, y: (diameter - textSize.height) / 2),
                withAttributes: attributes
            )
        }
        numberCache[number] = image
        return image
    }

    static var userLocation: UIImage {
        let diameter = userDotOuterRadius * 2
        let size = CGSize(width: diameter, height: diameter)
        return UIGraphicsImageRenderer(size: size).image { _ in
            UIColor.white.setFill()
            UIBezierPath(ovalIn: CGRect(origin: .zero, size: size)).fill()
            brandRed.setFill()
            let inset = userDotOuterRadius - userDotInnerRadius
            UIBezierPath(ovalIn: CGRect(origin: .zero, size: size).insetBy(dx: inset, dy: inset)).fill()
        }
    }
}
