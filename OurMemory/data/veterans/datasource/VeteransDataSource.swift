import Foundation

protocol VeteransDataSource: AnyObject {
    func allVeterans() async throws -> [Veteran]
}
