import SwiftUI

struct ContactsSection: View {
    private static let telScheme = "tel:"

    @Environment(\.openURL) private var openURL

    var body: some View {
        let openingHours = L10n.string("cemetery_opening_hours")
        let phone = L10n.string("cemetery_phone")
        if !openingHours.isBlank || !phone.isBlank {
            VStack(alignment: .leading, spacing: 0) {
                SectionTitle(text: "opening_hours")
                VStack(alignment: .leading, spacing: Spacing.l) {
                    if !openingHours.isBlank {
                        LabeledContent("opening_hours", value: openingHours)
                    }
                    if !phone.isBlank {
                        Button {
                            if let url = URL(string: Self.telScheme + phone.filter { return !$0.isWhitespace }) {
                                openURL(url)
                            }
                        } label: {
                            LabeledContent("phone", value: phone)
                        }
                    }
                }
                .cardBackground()
            }
        }
    }
}
