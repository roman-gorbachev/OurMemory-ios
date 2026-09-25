import SwiftUI

struct SwitchSettingRow: View {
    let systemImage: String
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    let isOn: Bool
    let onChange: (Bool) -> Void

    var body: some View {
        return SettingRow(systemImage: systemImage, title: title, subtitle: subtitle, action: { onChange(!isOn) }) {
            Toggle("", isOn: Binding(get: { return isOn }, set: onChange))
                .labelsHidden()
                .tint(Palette.primary)
        }
    }
}
