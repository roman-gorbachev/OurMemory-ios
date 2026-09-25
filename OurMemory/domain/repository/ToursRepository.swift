import Foundation

protocol ToursRepository: AnyObject {
    func allTours() async throws -> [Tour]
    func originalTours() async throws -> [Tour]
    func invalidate()
}
