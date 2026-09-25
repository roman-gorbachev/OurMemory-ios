import Foundation

nonisolated struct Submission: Hashable, Identifiable, Sendable {
    let id: String
    let veteranId: String
    let text: String
    let contact: String
    let photoPaths: [String]
    let status: ModerationStatus
    let createdAt: Int64
    var reply = ""
    var reviewedAt: Int64 = 0
}
