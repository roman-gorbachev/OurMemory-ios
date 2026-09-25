import SwiftUI

struct MoreScreen: View {
    private static let sectionSpacing: CGFloat = 20

    let data: MoreUiData
    let onAction: (MoreUserAction) -> Void
    let onGoogleSignIn: () -> Void
    let onWriteToUs: () -> Void
    let onMyRequests: () -> Void
    let onFavorites: () -> Void
    let onScanQr: () -> Void
    let onAdmin: () -> Void

    var body: some View {
        return ScrollView {
            VStack(alignment: .leading, spacing: Self.sectionSpacing) {
                Text("more")
                    .appStyle(.headlineMedium, weight: .bold)
                    .foregroundStyle(Palette.primary)
                MemoryBanner()
                AccountCard(
                    account: data.account,
                    signInStatus: data.signInStatus,
                    onSignIn: onGoogleSignIn,
                    onSignOut: { onAction(.signOut) }
                )
                personalGroup
                appearanceGroup
                remindersGroup
                AppButton(title: "sign_in_as_admin", kind: .text, action: onAdmin)
            }
            .padding(Spacing.screen)
            .padding(.bottom, Spacing.tabBarInset)
        }
        .background(Palette.background.ignoresSafeArea())
    }

    private var personalGroup: some View {
        return SettingsGroup(title: "mine") {
            SettingRow(systemImage: "envelope", title: "my_requests", action: onMyRequests) {
                HStack(spacing: Spacing.m) {
                    if data.unseenRequestsCount > 0 {
                        CountBadge(count: data.unseenRequestsCount)
                    }
                    ChevronIcon()
                }
            }
            SettingsDivider()
            SettingRow(systemImage: "heart.fill", title: "favorites", action: onFavorites)
            SettingsDivider()
            SettingRow(systemImage: "qrcode.viewfinder", title: "scan_qr_code", action: onScanQr)
            SettingsDivider()
            SettingRow(systemImage: "pencil", title: "write_to_us", action: onWriteToUs)
        }
    }

    private var appearanceGroup: some View {
        return SettingsGroup(title: "appearance") {
            ChoiceSettingRow(
                systemImage: "paintpalette",
                title: "theme",
                options: ThemeMode.allCases,
                selected: data.settings.themeMode,
                label: \.titleKey
            ) { onAction(.themeModeChanged($0)) }
            SettingsDivider()
            ChoiceSettingRow(
                systemImage: "textformat.size",
                title: "text_size",
                options: TextScale.allCases,
                selected: data.settings.textScale,
                label: \.titleKey
            ) { onAction(.textScaleChanged($0)) }
            SettingsDivider()
            ChoiceSettingRow(
                systemImage: "globe",
                title: "language",
                options: AppLanguage.allCases,
                selected: data.settings.language,
                label: \.titleKey
            ) { onAction(.languageChanged($0)) }
        }
    }

    private var remindersGroup: some View {
        return SettingsGroup(title: "reminders") {
            SwitchSettingRow(
                systemImage: "star.fill",
                title: "victory_day",
                subtitle: "in_the_morning_of_may_9_msg",
                isOn: data.settings.victoryDayReminder
            ) { onAction(.victoryDayReminderChanged($0)) }
            SettingsDivider()
            SwitchSettingRow(
                systemImage: "bell",
                title: "memorable_dates_of_favorites",
                subtitle: "on_birthdays_and_memorial_days_msg",
                isOn: data.settings.favoriteReminders
            ) { onAction(.favoriteRemindersChanged($0)) }
        }
    }
}

#Preview {
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
}
