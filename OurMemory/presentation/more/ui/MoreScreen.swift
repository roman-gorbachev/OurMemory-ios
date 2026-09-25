import SwiftUI

struct MoreScreen: View {
    let data: MoreUiData
    let onAction: (MoreUserAction) -> Void
    let onGoogleSignIn: () -> Void
    let onWriteToUs: () -> Void
    let onMyRequests: () -> Void
    let onFavorites: () -> Void
    let onScanQr: () -> Void
    let onAdmin: () -> Void

    var body: some View {
        return List {
            Section {
                MemoryBanner()
                    .listRowInsets(EdgeInsets())
            }
            Section {
                AccountRow(account: data.account, signInStatus: data.signInStatus, onSignIn: onGoogleSignIn) {
                    onAction(.signOut)
                }
            } footer: {
                Text(data.account == nil ? "sign_in_to_keep_favorites_msg" : "favorites_and_requests_are_saved_msg")
            }
            Section("mine") {
                DisclosureRow(title: "my_requests", systemImage: "envelope.fill", color: .blue, action: onMyRequests) {
                    if data.unseenRequestsCount > 0 {
                        CountBadge(count: data.unseenRequestsCount)
                    }
                }
                DisclosureRow(title: "favorites", systemImage: "heart.fill", color: .pink, action: onFavorites)
                DisclosureRow(title: "scan_qr_code", systemImage: "qrcode.viewfinder", color: .gray, action: onScanQr)
                DisclosureRow(title: "write_to_us", systemImage: "square.and.pencil", color: .green, action: onWriteToUs)
            }
            Section("appearance") {
                Picker(selection: Binding(get: { return data.settings.themeMode }, set: { onAction(.themeModeChanged($0)) })) {
                    ForEach(ThemeMode.allCases, id: \.self) { Text($0.titleKey).tag($0) }
                } label: {
                    Label { Text("theme") } icon: { SettingsIcon(systemImage: "circle.lefthalf.filled", color: .indigo) }
                }
                Picker(selection: Binding(get: { return data.settings.textScale }, set: { onAction(.textScaleChanged($0)) })) {
                    ForEach(TextScale.allCases, id: \.self) { Text($0.titleKey).tag($0) }
                } label: {
                    Label { Text("text_size") } icon: { SettingsIcon(systemImage: "textformat.size", color: .blue) }
                }
                Picker(selection: Binding(get: { return data.settings.language }, set: { onAction(.languageChanged($0)) })) {
                    ForEach(AppLanguage.allCases, id: \.self) { Text($0.titleKey).tag($0) }
                } label: {
                    Label { Text("language") } icon: { SettingsIcon(systemImage: "globe", color: .teal) }
                }
            }
            Section("reminders") {
                Toggle(isOn: Binding(get: { return data.settings.victoryDayReminder }, set: { onAction(.victoryDayReminderChanged($0)) })) {
                    Label {
                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                            Text("victory_day")
                            Text("in_the_morning_of_may_9_msg")
                                .appStyle(.footnote)
                                .foregroundStyle(Palette.onSurfaceVariant)
                        }
                    } icon: {
                        SettingsIcon(systemImage: "star.fill", color: Palette.primary)
                    }
                }
                Toggle(isOn: Binding(get: { return data.settings.favoriteReminders }, set: { onAction(.favoriteRemindersChanged($0)) })) {
                    Label {
                        VStack(alignment: .leading, spacing: Spacing.xxs) {
                            Text("memorable_dates_of_favorites")
                            Text("on_birthdays_and_memorial_days_msg")
                                .appStyle(.footnote)
                                .foregroundStyle(Palette.onSurfaceVariant)
                        }
                    } icon: {
                        SettingsIcon(systemImage: "bell.fill", color: .red)
                    }
                }
            }
            Section {
                Button("sign_in_as_admin", action: onAdmin)
                    .frame(maxWidth: .infinity)
            }
        }
        .listStyle(.insetGrouped)
    }
}

#Preview {
    NavigationStack {
        MoreScreen(
            data: MoreUiData(),
            onAction: { _ in },
            onGoogleSignIn: {},
            onWriteToUs: {},
            onMyRequests: {},
            onFavorites: {},
            onScanQr: {},
            onAdmin: {}
        )
        .navigationTitle("more")
    }
}
