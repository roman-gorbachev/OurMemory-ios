import Combine
import Foundation

extension Publisher {
    func firstValue() async throws -> Output {
        for try await value in values {
            return value
        }
        throw CancellationError()
    }
}
