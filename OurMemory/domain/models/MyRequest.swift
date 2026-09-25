import Foundation

nonisolated struct MyRequest: Hashable, Identifiable, Sendable {
    let id: String
    let kind: RequestKind
    let veteranId: String
    let text: String
    let status: RequestStatus
    let reply: String
    let createdAt: Int64
    let reviewedAt: Int64
}
