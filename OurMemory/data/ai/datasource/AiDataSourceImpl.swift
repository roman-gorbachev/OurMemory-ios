import FirebaseAILogic
import Foundation

nonisolated final class AiDataSourceImpl: AiDataSource, @unchecked Sendable {
    private static let modelName = "gemini-3.8-flash"
    private static let temperature: Float = 0.2
    private static let jsonMimeType = "application/json"
    private static let imageMimeType = "image/jpeg"
    private static let userRole = "user"
    private static let modelRole = "model"

    private let ai: FirebaseAI

    init(ai: FirebaseAI) {
        self.ai = ai
    }

    func generate(_ request: AiRequest) async throws -> String {
        let model = ai.generativeModel(
            modelName: Self.modelName,
            generationConfig: GenerationConfig(
                temperature: Self.temperature,
                maxOutputTokens: request.maxOutputTokens,
                responseMIMEType: request.responseSchema == nil ? nil : Self.jsonMimeType,
                responseSchema: request.responseSchema
            ),
            systemInstruction: ModelContent(role: nil, parts: request.systemInstruction)
        )
        let history = request.history.map { message in
            return ModelContent(role: message.isFromUser ? Self.userRole : Self.modelRole, parts: message.text)
        }
        let imageParts: [any Part] = request.images.map { return InlineDataPart(data: $0, mimeType: Self.imageMimeType) }
        let prompt = ModelContent(role: Self.userRole, parts: imageParts + [TextPart(request.prompt)])
        let response = try await model.generateContent(history + [prompt])
        guard let text = response.text, !text.isBlank else {
            throw AiError.emptyResponse
        }
        return text
    }
}
