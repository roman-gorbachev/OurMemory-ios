import Combine
import Foundation

protocol CandlesLocalDataSource: AnyObject {
    func lastLitDatePublisher(veteranId: String) -> AnyPublisher<String?, Never>
    func lastLitDate(veteranId: String) -> String?
    func saveLastLitDate(veteranId: String, date: String)
}
