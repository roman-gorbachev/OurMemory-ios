import Foundation
@testable import OurMemory

final class FakeAccountIndexDataSource: AccountIndexDataSource {
    private(set) var accounts: [String: String] = [:]

    func register(uid: String, email: String) async throws {
        accounts[email] = uid
    }
}
