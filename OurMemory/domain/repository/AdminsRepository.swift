import Combine
import Foundation

protocol AdminsRepository: AnyObject {
    func adminsPublisher() -> AnyPublisher<[AdminAccount], Error>
    func addAdmin(email: String) async throws -> AddAdminResult
    func removeAdmin(uid: String) async throws
}
