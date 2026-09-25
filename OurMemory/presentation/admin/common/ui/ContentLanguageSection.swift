import SwiftUI

struct ContentLanguageSection: View {
    let language: AppLanguage
    let onChange: (AppLanguage) -> Void

    var body: some View {
        Section {
            Picker("content_language", selection: Binding(get: { return language }, set: { onChange($0) })) {
                ForEach(AppLanguage.allCases, id: \.self) { Text($0.titleKey).tag($0) }
            }
            .pickerStyle(.segmented)
        } header: {
            Text("content_language")
        } footer: {
            if language != .russian {
                Text("translation_is_optional_msg")
            }
        }
    }
}
