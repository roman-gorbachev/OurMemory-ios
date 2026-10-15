import Foundation

nonisolated struct SubmissionAnalysisInput: Sendable {
    let veteranName: String
    let years: String
    let birthDate: String
    let deathDate: String
    let biography: String
    let rewards: [String]
    let cardMaterials: [String]
    let submissionText: String
    let photoUrls: [String]
}
