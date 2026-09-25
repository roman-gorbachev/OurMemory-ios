import XCTest
@testable import OurMemory

final class IsoDateTests: XCTestCase {
    func testBlankOrIsoDatesAreValid() {
        XCTAssertTrue(IsoDate.isBlankOrValid(""))
        XCTAssertTrue(IsoDate.isBlankOrValid("1905-08-03"))
    }

    func testOtherFormatsAndImpossibleDatesAreInvalid() {
        XCTAssertFalse(IsoDate.isBlankOrValid("03.08.1905"))
        XCTAssertFalse(IsoDate.isBlankOrValid("1905-02-30"))
    }
}
