import Foundation

protocol AccountIndexDataSource: AnyObject {
    func register(uid: String, email: String) async throws
}
