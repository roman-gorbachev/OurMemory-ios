import Foundation

final class ContentCheckRepositoryImpl: ContentCheckRepository {
    private let profanityDetector: ProfanityDetector
    private let latinProfanityDetector: LatinProfanityDetector
    private let extremismDetector: ExtremismDetector
    private let imageClassifier: NsfwImageClassifier

    init(
        profanityDetector: ProfanityDetector,
        latinProfanityDetector: LatinProfanityDetector,
        extremismDetector: ExtremismDetector,
        imageClassifier: NsfwImageClassifier
    ) {
        self.profanityDetector = profanityDetector
        self.latinProfanityDetector = latinProfanityDetector
        self.extremismDetector = extremismDetector
        self.imageClassifier = imageClassifier
    }

    func containsOffensiveText(_ text: String) -> Bool {
        return profanityDetector.containsProfanity(text)
            || latinProfanityDetector.containsProfanity(text)
            || extremismDetector.containsExtremism(text)
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
