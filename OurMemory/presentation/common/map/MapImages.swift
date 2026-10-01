import UIKit

enum MapImages {
    private static let numberRadius: CGFloat = 20
    private static let numberStroke: CGFloat = 2
    private static let numberFontSize: CGFloat = 14
    private static let userDotOuterRadius: CGFloat = 11
    private static let userDotInnerRadius: CGFloat = 7.5
    private static let brandRed = UIColor(red: 0x7F / 255.0, green: 0x04 / 255.0, blue: 0x10 / 255.0, alpha: 1)
    private static let markerWidth: CGFloat = 32
    private static let markerHeight: CGFloat = 42
    private static let markerStroke: CGFloat = 2
    private static let markerHoleRatio: CGFloat = 0.36
    private static let markerArcStart: CGFloat = .pi * 0.8
    private static let markerArcEnd: CGFloat = .pi * 0.2
    private static var numberCache: [Int: UIImage] = [:]
    private static var markerCache: UIImage?

    static let markerAnchor = CGPoint(x: 0.5, y: 1)

    static var marker: UIImage {
        if let markerCache {
            return markerCache
        }
        let size = CGSize(width: markerWidth, height: markerHeight)
        let image = UIGraphicsImageRenderer(size: size).image { _ in
            let center = CGPoint(x: markerWidth / 2, y: markerWidth / 2)
            let radius = markerWidth / 2 - markerStroke
            let pin = UIBezierPath()
            pin.addArc(withCenter: center, radius: radius, startAngle: markerArcStart, endAngle: markerArcEnd, clockwise: true)
            pin.addLine(to: CGPoint(x: markerWidth / 2, y: markerHeight - markerStroke))
            pin.close()
            pin.lineJoinStyle = .round
            brandRed.setFill()
            pin.fill()
            UIColor.white.setStroke()
            pin.lineWidth = markerStroke
            pin.stroke()
            UIColor.white.setFill()
            UIBezierPath(arcCenter: center, radius: radius * markerHoleRatio, startAngle: 0, endAngle: .pi * 2, clockwise: true).fill()
        }
        markerCache = image
        return image
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
