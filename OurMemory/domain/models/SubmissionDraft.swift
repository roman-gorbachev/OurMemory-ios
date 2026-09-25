import Foundation

nonisolated struct SubmissionDraft: Hashable, Sendable {
    let veteranId: String
    let text: String
    let contact: String
    let photos: [Data]
}
