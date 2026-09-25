import XCTest
@testable import OurMemory

final class ScaledSizeTests: XCTestCase {
    private static let maxSide = 2048

    func testSmallPhotoKeepsItsSize() {
        let size = ScaledSize.fitting(width: 1200, height: 900, maxSide: Self.maxSide)
        XCTAssertEqual(size.width, 1200)
        XCTAssertEqual(size.height, 900)
    }

    func testLandscapePhotoIsScaledByWidth() {
        let size = ScaledSize.fitting(width: 4000, height: 3000, maxSide: Self.maxSide)
        XCTAssertEqual(size.width, 2048)
        XCTAssertEqual(size.height, 1536)
    }

    func testPortraitPhotoIsScaledByHeight() {
        let size = ScaledSize.fitting(width: 2250, height: 4000, maxSide: Self.maxSide)
        XCTAssertEqual(size.width, 1152)
        XCTAssertEqual(size.height, 2048)
    }
}
