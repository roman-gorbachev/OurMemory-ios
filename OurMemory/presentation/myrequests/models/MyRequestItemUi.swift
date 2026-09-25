import Foundation

struct MyRequestItemUi: Hashable, Identifiable {
    let requestId: String
    let kind: RequestKind
    let veteranName: String
    let text: String
    let status: RequestStatus
    let reply: String
    let date: String

    var id: String {
        return "\(kind)_\(requestId)"
    }
}
