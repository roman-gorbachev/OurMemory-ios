import XCTest
@testable import OurMemory

final class VeteranAnniversariesTests: XCTestCase {
    private var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Europe/Minsk") ?? .current
        return calendar
    }

    private func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        return calendar.date(from: DateComponents(year: year, month: month, day: day)) ?? Date()
    }

    func testMatchesBirthAndDeathByDayAndMonth() {
        let veteran = Veteran(birthDate: "1905-08-03", deathDate: "1966-08-03")
        XCTAssertEqual(
            veteran.anniversaries(on: date(2026, 8, 3), calendar: calendar),
            [Anniversary(kind: .birthday, year: 1905), Anniversary(kind: .memoryDay, year: 1966)]
        )
    }

    func testIgnoresOtherDaysAndBrokenDates() {
        XCTAssertEqual(Veteran(birthDate: "1905-08-03").anniversaries(on: date(2026, 8, 4), calendar: calendar), [])
        XCTAssertEqual(Veteran(birthDate: "03.08.1905").anniversaries(on: date(2026, 8, 3), calendar: calendar), [])
    }
}
