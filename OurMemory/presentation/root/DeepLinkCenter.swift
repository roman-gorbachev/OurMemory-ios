import Foundation

@Observable
final class DeepLinkCenter {
    static let shared = DeepLinkCenter()

    var pendingVeteranId: String?
    private(set) var hasReceivedLink = false

    func handle(_ url: URL) -> Bool {
        guard let veteranId = VeteranLink.parseVeteranId(url.absoluteString) else {
            return false
        }
        hasReceivedLink = true
        pendingVeteranId = veteranId
        return true
    }
}
