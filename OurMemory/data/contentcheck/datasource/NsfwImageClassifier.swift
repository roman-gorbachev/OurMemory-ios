import CoreML
import Foundation
import Vision

nonisolated final class NsfwImageClassifier: @unchecked Sendable {
    private static let modelName = "NsfwClassifier"
    private static let compiledModelExtension = "mlmodelc"
    private static let hentaiIndex = 1
    private static let pornIndex = 3
    private static let sexyIndex = 4
    private static let classCount = 5

    private let lock = NSLock()
    private var cachedModel: VNCoreMLModel?

    func classify(_ imageData: Data) throws -> NsfwScores {
        let request = VNCoreMLRequest(model: try model())
        request.imageCropAndScaleOption = .scaleFill
        try VNImageRequestHandler(data: imageData).perform([request])
        guard let observation = request.results?.first as? VNCoreMLFeatureValueObservation,
              let scores = observation.featureValue.multiArrayValue,
              scores.count >= Self.classCount else {
            throw NsfwClassificationError.noResult
        }
        return NsfwScores(
            hentai: scores[Self.hentaiIndex].floatValue,
            porn: scores[Self.pornIndex].floatValue,
            sexy: scores[Self.sexyIndex].floatValue
        )
    }

    private func model() throws -> VNCoreMLModel {
        lock.lock()
        defer { lock.unlock() }
        if let cachedModel {
            return cachedModel
        }
        guard let url = Bundle.main.url(forResource: Self.modelName, withExtension: Self.compiledModelExtension) else {
            throw NsfwClassificationError.modelMissing
        }
        let model = try VNCoreMLModel(for: MLModel(contentsOf: url))
        cachedModel = model
        return model
    }
}
