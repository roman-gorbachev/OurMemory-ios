import Foundation

protocol AiDataSource: AnyObject, Sendable {
    func generate(_ request: AiRequest) async throws -> String
}
