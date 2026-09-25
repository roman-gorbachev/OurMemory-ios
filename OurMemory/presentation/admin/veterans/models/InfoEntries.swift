import Foundation

enum InfoEntries {
    static func entries(from veteransInfo: [String]) -> [InfoEntry] {
        return veteransInfo.map { entry in
            guard entry.contains(VeteranInfoFormat.linkMarker) else {
                return InfoEntry(id: UUID(), kind: .paragraph(text: entry))
            }
            let parts = entry.split(separator: Character(VeteranInfoFormat.descriptionSeparator), maxSplits: 1, omittingEmptySubsequences: false)
            let url = String(parts.first ?? "")
            let caption = parts.count > 1 ? String(parts[1]) : ""
            return InfoEntry(id: UUID(), kind: .media(url: url, caption: caption))
        }
    }

    static func veteransInfo(from entries: [InfoEntry]) -> [String] {
        return entries.compactMap { entry in
            switch entry.kind {
            case .paragraph(let text):
                return text.isBlank ? nil : text
            case .media(let url, let caption):
                return caption.isBlank ? url : "\(url)\(VeteranInfoFormat.descriptionSeparator)\(caption)"
            }
        }
    }
}
