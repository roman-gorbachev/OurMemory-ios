import Combine
import Foundation

protocol MyRequestsRepository: AnyObject {
    func myRequestsPublisher() -> AnyPublisher<[MyRequest], Error>
    func unseenCountPublisher() -> AnyPublisher<Int, Never>
    func markAllSeen()
}
