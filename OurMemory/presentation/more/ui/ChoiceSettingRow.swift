import SwiftUI

struct ChoiceSettingRow<Option: Hashable>: View {
    let systemImage: String
    let title: LocalizedStringKey
    let options: [Option]
    let selected: Option
    let label: (Option) -> LocalizedStringKey
    let onSelect: (Option) -> Void

    var body: some View {
        return Menu {
            ForEach(options, id: \.self) { option in
                Button {
                    onSelect(option)
                } label: {
                    if option == selected {
                        Label(label(option), systemImage: "checkmark")
                    } else {
                        Text(label(option))
                    }
                }
            }
        } label: {
            HStack(spacing: Spacing.l) {
                SettingIcon(systemImage: systemImage)
                Text(title)
                    .appStyle(.titleMedium)
                    .foregroundStyle(Palette.onSurface)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack(spacing: Spacing.xxs) {
                    Text(label(selected))
                        .appStyle(.bodyMedium, weight: .semibold)
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.caption)
                }
                .foregroundStyle(Palette.primary)
            }
            .padding(.horizontal, Spacing.l + Spacing.xxs)
            .padding(.vertical, Spacing.l)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
