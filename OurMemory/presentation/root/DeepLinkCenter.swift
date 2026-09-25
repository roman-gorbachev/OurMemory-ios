import Foundation

@Observable
final class DeepLinkCenter {
    static let shared = DeepLinkCenter()

    var pendingVeteranId: String?

    func handle(_ url: URL) -> Bool {
        guard let veteranId = VeteranLink.parseVeteranId(url.absoluteString) else {
            return false
        }
        pendingVeteranId = veteranId
        return true
    }
}
