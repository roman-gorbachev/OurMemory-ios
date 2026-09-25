import Foundation

protocol BurialsRepository: AnyObject {
    func allBurials() async throws -> [Burial]
    func originalBurials() async throws -> [Burial]
    func invalidate()
}
