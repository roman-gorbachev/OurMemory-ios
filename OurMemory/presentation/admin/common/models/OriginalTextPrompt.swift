import SwiftUI

enum OriginalTextPrompt {
    static func prompt(_ original: String, language: AppLanguage) -> Text? {
        guard language != .russian, !original.isBlank else {
            return nil
        }
        return Text(verbatim: original)
    }
}
