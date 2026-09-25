import Foundation

enum InfoEntryKind: Hashable {
    case paragraph(text: String)
    case media(url: String, caption: String)
}
