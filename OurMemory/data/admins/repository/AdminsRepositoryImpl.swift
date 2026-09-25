import Combine
import Foundation

final class AdminsRepositoryImpl: AdminsRepository {
    private let dataSource: AdminsDataSource

    init(dataSource: AdminsDataSource) {
        self.dataSource = dataSource
    }

    func adminsPublisher() -> AnyPublisher<[AdminAccount], Error> {
        let emails = dataSource.accountEmailsPublisher()
            .prepend([:])
            .catch { _ in return Just([String: String]()).setFailureType(to: Error.self) }
        return dataSource.adminUidsPublisher()
            .combineLatest(dataSource.superAdminUidsPublisher(), emails)
            .map { adminUids, superAdminUids, emails in
                return adminUids.union(superAdminUids)
                    .map { uid in
                        return AdminAccount(uid: uid, email: emails[uid] ?? "", isSuperAdmin: superAdminUids.contains(uid))
                    }
                    .sorted { first, second in
                        if first.isSuperAdmin != second.isSuperAdmin {
                            return first.isSuperAdmin
                        }
                        let firstName = first.email.isEmpty ? first.uid : first.email
                        let secondName = second.email.isEmpty ? second.uid : second.email
                        return firstName.localizedStandardCompare(secondName) == .orderedAscending
                    }
            }
            .eraseToAnyPublisher()
    }

    func addAdmin(email: String) async throws -> AddAdminResult {
        guard let uid = try await dataSource.findUid(email: email) else {
            return .accountNotFound
        }
        if try await dataSource.isAdmin(uid: uid) {
            return .alreadyAdmin
        }
        try await dataSource.setAdmin(uid: uid)
        return .added
    }

    func removeAdmin(uid: String) async throws {
        try await dataSource.removeAdmin(uid: uid)
    }
}
