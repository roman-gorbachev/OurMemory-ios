import Foundation

protocol ContentCheckRepository: AnyObject {
    func containsProfanity(_ text: String) -> Bool
    func checkPhoto(_ imageData: Data) async -> PhotoCheckResult
}
