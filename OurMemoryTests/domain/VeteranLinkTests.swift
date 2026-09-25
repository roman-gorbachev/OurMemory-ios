import XCTest
@testable import OurMemory

final class VeteranLinkTests: XCTestCase {
    func testParsesVeteranIdFromOurLink() {
        XCTAssertEqual(VeteranLink.parseVeteranId("https://chatroom-85fb8.web.app/veteran/10"), "10")
        XCTAssertEqual(VeteranLink.parseVeteranId(" https://chatroom-85fb8.web.app/veteran/10/?utm=qr "), "10")
    }

    func testRejectsForeignAndEmptyCodes() {
        XCTAssertNil(VeteranLink.parseVeteranId("https://example.com/veteran/10"))
        XCTAssertNil(VeteranLink.parseVeteranId("https://chatroom-85fb8.web.app/veteran/"))
        XCTAssertNil(VeteranLink.parseVeteranId(""))
        XCTAssertNil(VeteranLink.parseVeteranId("https://chatroom-85fb8.web.app/veteran/10/photos"))
    }
}
