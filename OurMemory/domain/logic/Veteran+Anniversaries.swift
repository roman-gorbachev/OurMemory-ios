import Foundation

nonisolated extension Veteran {
    func anniversaries(on date: Date, calendar: Calendar) -> [Anniversary] {
        let today = IsoDate(date: date, calendar: calendar)
        return [
            anniversary(from: birthDate, kind: .birthday, today: today),
            anniversary(from: deathDate, kind: .memoryDay, today: today)
        ]
        .compactMap { return $0 }
    }

    private func anniversary(from text: String, kind: AnniversaryKind, today: IsoDate) -> Anniversary? {
        guard let parsed = IsoDate(text), parsed.month == today.month, parsed.day == today.day else {
            return nil
        }
        return Anniversary(kind: kind, year: parsed.year)
    }
}
