import Combine
import Foundation

protocol CandlesRepository: AnyObject {
    func candleStatePublisher(veteranId: String) -> AnyPublisher<CandleState, Error>
    func lightCandle(veteranId: String) async throws
}
