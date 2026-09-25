import Foundation

struct SubmissionItemUi: Hashable, Identifiable {
    let id: String
    let veteranName: String
    let text: String
    let photoCount: Int
    let status: ModerationStatus
    let date: String
}
