import Foundation

final class ContentCheckRepositoryImpl: ContentCheckRepository {
    private let profanityDetector: ProfanityDetector
    private let imageClassifier: NsfwImageClassifier

    init(profanityDetector: ProfanityDetector, imageClassifier: NsfwImageClassifier) {
        self.profanityDetector = profanityDetector
        self.imageClassifier = imageClassifier
    }

    func containsProfanity(_ text: String) -> Bool {
        return profanityDetector.containsProfanity(text)
    }

    func checkPhoto(_ imageData: Data) async -> PhotoCheckResult {
        let classifier = imageClassifier
        return await Task.detached {
            guard let scores = try? classifier.classify(imageData) else {
                return PhotoCheckResult.unreadable
            }
            return scores.isExplicit ? PhotoCheckResult.blocked : PhotoCheckResult.allowed
        }.value
    }
}
