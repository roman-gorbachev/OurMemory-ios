import Combine
import Foundation

protocol CandlesRemoteDataSource: AnyObject {
    func candlesPublisher(veteranId: String) -> AnyPublisher<Int64, Error>
    func lightCandle(veteranId: String) async throws
}
