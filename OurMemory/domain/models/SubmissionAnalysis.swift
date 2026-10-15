import Foundation

nonisolated struct SubmissionAnalysis: Decodable, Hashable, Sendable {
    let summary: String
    let suggestedText: String
    let conflicts: [String]
    let duplicateOf: String
    let documentTranscripts: [String]
    let suggestedReply: String

    enum CodingKeys: String, CodingKey {
        case summary
        case suggestedText = "suggested_text"
        case conflicts
        case duplicateOf = "duplicate_of"
        case documentTranscripts = "document_transcripts"
        case suggestedReply = "suggested_reply"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        summary = container.lenientString(forKey: .summary)
        suggestedText = container.lenientString(forKey: .suggestedText)
        conflicts = container.lenientStrings(forKey: .conflicts).filter { return !$0.isBlank }
        duplicateOf = container.lenientString(forKey: .duplicateOf)
        documentTranscripts = container.lenientStrings(forKey: .documentTranscripts).filter { return !$0.isBlank }
        suggestedReply = container.lenientString(forKey: .suggestedReply)
    }
}
