import SwiftUI

struct IsoDateField: View {
    private static let firstYear = 1850

    let label: LocalizedStringKey
    let date: String
    let isValid: Bool
    let onChange: (String) -> Void
    @State private var isPickerPresented = false
    @State private var pickedDate = Date()

    var body: some View {
        return HStack(spacing: Spacing.m) {
            Button {
                pickedDate = IsoDate(date)?.date(in: Self.calendar) ?? Date()
                isPickerPresented = true
            } label: {
                HStack {
                    Text(label)
                    Text(verbatim: ": \(date.isBlank ? L10n.string("not_specified") : date)")
                }
                .foregroundStyle(isValid ? Palette.primary : Palette.error)
            }
            .buttonStyle(AppButtonStyle(kind: .outlined))
            if !date.isBlank {
                Button {
                    onChange("")
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(Palette.onSurfaceVariant)
                }
                .accessibilityLabel("clear")
            }
        }
        .sheet(isPresented: $isPickerPresented) {
            VStack(spacing: Spacing.xl) {
                DatePicker("", selection: $pickedDate, in: Self.range, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .environment(\.calendar, Self.calendar)
                    .environment(\.timeZone, Self.calendar.timeZone)
                AppButton(title: "done") {
                    onChange(IsoDate(date: pickedDate, calendar: Self.calendar).text)
                    isPickerPresented = false
                }
            }
            .padding(Spacing.xl)
            .presentationDetents([.medium, .large])
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
