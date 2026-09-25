import Combine
import Foundation

protocol TourProgressRepository: AnyObject {
    func progressPublisher() -> AnyPublisher<[String: Set<Int>], Never>
    func toggleStop(tourId: String, stopIndex: Int)
    func reset(tourId: String)
}
