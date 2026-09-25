import XCTest
@testable import OurMemory

final class AuthRepositoryImplTests: XCTestCase {
    private let admin = AuthUser(uid: "admin-uid", email: "admin@memory.by", isAnonymous: false)
    private let editor = AuthUser(uid: "editor-uid", email: "editor@memory.by", isAnonymous: false)
    private let visitor = AuthUser(uid: "visitor-uid", email: "", isAnonymous: true)
    private lazy var dataSource = FakeAuthDataSource(
        accounts: [admin.email: admin, editor.email: editor],
        adminUids: [admin.uid, visitor.uid]
    )
    private lazy var repository = AuthRepositoryImpl(dataSource: dataSource)

    func testSignedOutUserIsNotAdmin() async throws {
        let session = try await repository.sessionPublisher().firstValue()
        XCTAssertEqual(session, AdminSession())
    }

    func testAnonymousUserIsNotAdminEvenWithAdminRecord() async throws {
        dataSource.user.send(visitor)
        let session = try await repository.sessionPublisher().firstValue()
        XCTAssertEqual(session, AdminSession())
    }

    func testUserListedInAdminsIsAdmin() async throws {
        dataSource.user.send(admin)
        let session = try await repository.sessionPublisher().firstValue()
        XCTAssertEqual(session, AdminSession(email: admin.email, isAdmin: true))
    }

    func testRemovingAdminRecordRevokesRole() async throws {
        dataSource.user.send(admin)
        dataSource.admins.send([])
        let session = try await repository.sessionPublisher().firstValue()
        XCTAssertFalse(session.isAdmin)
    }

    func testSignInReportsWrongCredentials() async throws {
        let result = try await repository.signIn(email: admin.email, password: "wrong")
        XCTAssertEqual(result, .wrongCredentials)
    }

    func testSignInAsAdminKeepsSession() async throws {
        let result = try await repository.signIn(email: admin.email, password: FakeAuthDataSource.password)
        XCTAssertEqual(result, .admin)
        XCTAssertEqual(dataSource.user.value, admin)
    }

    func testSignInWithoutAdminRecordSignsOut() async throws {
        let result = try await repository.signIn(email: editor.email, password: FakeAuthDataSource.password)
        XCTAssertEqual(result, .notAdmin)
        XCTAssertNil(dataSource.user.value)
    }
}
