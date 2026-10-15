import FirebaseAILogic
import Foundation

final class SubmissionAnalysisRepositoryImpl: SubmissionAnalysisRepository {
    private static let maxPhotos = 4
    private static let listSeparator = ", "
    private static let lineSeparator = "\n"
    private static let materialPrefix = "- "
    private static let systemInstruction = """
    Ты помогаешь модератору мемориального приложения о ветеранах, похороненных на военном кладбище в Минске. \
    Посетители присылают воспоминания и фотографии для карточки ветерана. \
    Проанализируй заявку и верни JSON:
    summary — одно-два предложения по-русски о том, что содержит заявка;
    suggested_text — текст заявки с исправленными орфографией, пунктуацией и стилем на языке оригинала, \
    без изменения, удаления и добавления фактов;
    conflicts — расхождения заявки с карточкой (даты, награды, места, имена) по-русски, пустой список, если их нет;
    duplicate_of — дословный фрагмент материалов карточки, который заявка повторяет, или пустая строка;
    document_transcripts — дословная расшифровка текста документов, писем и наградных листов на фотографиях, \
    по одному элементу на документ, пустой список, если документов нет;
    suggested_reply — короткий вежливый ответ автору на языке заявки, без обещаний одобрения.
    Никогда не придумывай факты, которых нет в заявке, карточке или на фотографиях.
    """
    private static let responseSchema = Schema.object(properties: [
        "summary": .string(),
        "suggested_text": .string(),
        "conflicts": .array(items: .string()),
        "duplicate_of": .string(),
        "document_transcripts": .array(items: .string()),
        "suggested_reply": .string()
    ])

    private let aiDataSource: AiDataSource
    private let photoDownloader: PhotoDownloader

    init(aiDataSource: AiDataSource, photoDownloader: PhotoDownloader) {
        self.aiDataSource = aiDataSource
        self.photoDownloader = photoDownloader
    }

    func analyze(_ input: SubmissionAnalysisInput) async throws -> SubmissionAnalysis {
        let photos = await photoDownloader.scaledJpegs(from: Array(input.photoUrls.prefix(Self.maxPhotos)))
        let request = AiRequest(
            systemInstruction: Self.systemInstruction,
            prompt: Self.prompt(for: input, photoCount: photos.count),
            images: photos,
            responseSchema: Self.responseSchema
        )
        let json = try await aiDataSource.generate(request)
        return try JSONDecoder().decode(SubmissionAnalysis.self, from: Data(json.utf8))
    }

    private static func prompt(for input: SubmissionAnalysisInput, photoCount: Int) -> String {
        let materials = input.cardMaterials.map { return materialPrefix + $0 }.joined(separator: lineSeparator)
        return """
        КАРТОЧКА ВЕТЕРАНА
        Имя: \(input.veteranName)
        Годы жизни: \(input.years)
        Дата рождения: \(input.birthDate)
        Дата смерти: \(input.deathDate)
        Награды: \(input.rewards.joined(separator: listSeparator))
        Биография: \(input.biography)
        Материалы карточки:
        \(materials)

        ЗАЯВКА ПОСЕТИТЕЛЯ
        \(input.submissionText)

        Фотографий в заявке: \(photoCount)
        """
    }
}
