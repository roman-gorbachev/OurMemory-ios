import Combine
import FirebaseDatabase
import Foundation

final class CandlesRemoteDataSourceImpl: CandlesRemoteDataSource {
    private let root: DatabaseReference

    init(root: DatabaseReference) {
        self.root = root
    }

    func candlesPublisher(veteranId: String) -> AnyPublisher<Int64, Error> {
        return root.child(DatabaseNodes.candles).child(veteranId)
            .valuePublisher()
            .map { return Self.candleCount(from: $0.value) }
            .eraseToAnyPublisher()
    }

    func lightCandle(veteranId: String) async throws {
        _ = try await root.child(DatabaseNodes.candles).child(veteranId).runTransactionBlock { currentData in
            currentData.value = Self.candleCount(from: currentData.value) + 1
            return TransactionResult.success(withValue: currentData)
        }
    }

    nonisolated private static func candleCount(from value: Any?) -> Int64 {
        if let number = value as? NSNumber {
            return number.int64Value
        }
        if let text = value as? String {
            return Int64(text) ?? 0
        }
        return 0
    }
}
