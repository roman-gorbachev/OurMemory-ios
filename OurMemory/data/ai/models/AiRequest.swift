import FirebaseAILogic
import Foundation

nonisolated struct AiRequest: @unchecked Sendable {
    let systemInstruction: String
    let prompt: String
    var images: [Data] = []
    var history: [AiMessage] = []
    var responseSchema: Schema?
    var maxOutputTokens: Int?
}
