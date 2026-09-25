import Foundation

protocol VeteransRepository: AnyObject {
    func allVeterans() async throws -> [Veteran]
    func originalVeterans() async throws -> [Veteran]
    func resolveDirectUrl(_ url: String) async -> String
    func invalidate()
}
