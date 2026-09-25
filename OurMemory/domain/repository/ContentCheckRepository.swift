import Foundation

protocol ContentCheckRepository: AnyObject {
    func containsOffensiveText(_ text: String) -> Bool
    func checkPhoto(_ imageData: Data) async -> PhotoCheckResult
}
