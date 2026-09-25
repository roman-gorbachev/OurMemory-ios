import XCTest
@testable import OurMemory

final class ProfanityDetectorTests: XCTestCase {
    private let detector = ProfanityDetector()

    func testCleanTextPasses() {
        XCTAssertFalse(detector.containsProfanity("Мой прадед служил в команде разведчиков, любил хлеб и мандарины"))
    }

    func testObsceneWordsAreFound() {
        XCTAssertTrue(detector.containsProfanity("Ну ты и сука"))
        XCTAssertTrue(detector.containsProfanity("ХУУУЙ"))
    }

    func testLatinLookalikesAndSpacedLettersAreFound() {
        XCTAssertTrue(detector.containsProfanity("cyka"))
        XCTAssertTrue(detector.containsProfanity("х у й"))
    }
}
