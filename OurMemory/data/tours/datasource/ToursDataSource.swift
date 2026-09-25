import Foundation

protocol ToursDataSource: AnyObject {
    func allTours() async throws -> [Tour]
}
