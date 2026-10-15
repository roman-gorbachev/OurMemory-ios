import Foundation

nonisolated struct AiMessage: Hashable, Sendable {
    let isFromUser: Bool
    let text: String
}
