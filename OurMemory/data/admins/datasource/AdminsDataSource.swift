import Combine
import Foundation

protocol AdminsDataSource: AnyObject {
    func adminUidsPublisher() -> AnyPublisher<Set<String>, Error>
    func superAdminUidsPublisher() -> AnyPublisher<Set<String>, Error>
    func accountEmailsPublisher() -> AnyPublisher<[String: String], Error>
    func findUid(email: String) async throws -> String?
    func isAdmin(uid: String) async throws -> Bool
    func setAdmin(uid: String) async throws
    func removeAdmin(uid: String) async throws
}
