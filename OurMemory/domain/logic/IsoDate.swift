import Foundation

nonisolated struct IsoDate: Hashable, Sendable {
    private static let separator: Character = "-"
    private static let yearLength = 4
    private static let monthDayLength = 2
    private static let partCount = 3

    let year: Int
    let month: Int
    let day: Int

    init?(_ text: String) {
        let parts = text.split(separator: Self.separator, omittingEmptySubsequences: false)
        guard parts.count == Self.partCount,
              parts[0].count == Self.yearLength,
              parts[1].count == Self.monthDayLength,
              parts[2].count == Self.monthDayLength,
              parts.allSatisfy({ return $0.allSatisfy(\.isASCIIDigit) }),
              let year = Int(parts[0]),
              let month = Int(parts[1]),
              let day = Int(parts[2]) else {
            return nil
        }
        let components = DateComponents(calendar: Self.calendar, year: year, month: month, day: day)
        guard components.isValidDate else {
            return nil
        }
        self.year = year
        self.month = month
        self.day = day
    }

    init(date: Date, calendar: Calendar) {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        year = components.year ?? 0
        month = components.month ?? 0
        day = components.day ?? 0
    }

    var text: String {
        return String(format: "%04d-%02d-%02d", year, month, day)
    }

    func date(in calendar: Calendar) -> Date? {
        return calendar.date(from: DateComponents(year: year, month: month, day: day))
    }

    static func isBlankOrValid(_ text: String) -> Bool {
        return text.trimmingCharacters(in: .whitespaces).isEmpty || IsoDate(text) != nil
    }

    private static var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        return calendar
    }
}

nonisolated private extension Character {
    var isASCIIDigit: Bool {
        return isASCII && isNumber
    }
}
