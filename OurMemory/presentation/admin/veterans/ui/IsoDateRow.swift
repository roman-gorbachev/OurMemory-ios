import SwiftUI

struct IsoDateRow: View {
    private static let firstYear = 1850

    let title: LocalizedStringKey
    let date: String
    let onChange: (String) -> Void

    var body: some View {
        let parsed = IsoDate(date)?.date(in: Self.calendar)
        return HStack {
            if let parsed {
                DatePicker(
                    title,
                    selection: Binding(get: { return parsed }, set: { onChange(IsoDate(date: $0, calendar: Self.calendar).text) }),
                    in: Self.range,
                    displayedComponents: .date
                )
                .environment(\.calendar, Self.calendar)
                .environment(\.timeZone, Self.calendar.timeZone)
                Button {
                    onChange("")
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Palette.tertiaryLabel)
                }
                .buttonStyle(.borderless)
                .accessibilityLabel("clear")
            } else {
                Text(title)
                Spacer()
                Button("not_specified") {
                    onChange(IsoDate(date: Date(), calendar: Self.calendar).text)
                }
                .buttonStyle(.bordered)
                .foregroundStyle(date.isBlank ? Palette.onSurfaceVariant : Palette.error)
            }
        }
    }

    private static var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        return calendar
    }

    private static var range: ClosedRange<Date> {
        let start = calendar.date(from: DateComponents(year: firstYear, month: 1, day: 1)) ?? .distantPast
        return start...Date()
    }
}
