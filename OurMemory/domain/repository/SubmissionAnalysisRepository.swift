import Foundation

protocol SubmissionAnalysisRepository: AnyObject {
    func analyze(_ input: SubmissionAnalysisInput) async throws -> SubmissionAnalysis
}
