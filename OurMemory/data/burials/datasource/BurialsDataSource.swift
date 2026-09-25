import Foundation

protocol BurialsDataSource: AnyObject {
    func allBurials() async throws -> [Burial]
}
