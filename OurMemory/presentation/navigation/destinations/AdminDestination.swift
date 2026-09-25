import Foundation

enum AdminDestination: Hashable {
    case guide(section: GuideSection?)
    case feedback
    case moderation
    case submission(submissionId: String)
    case veterans
    case veteranEditor(veteranId: String)
    case burials
    case burialEditor(burialId: String)
    case tours
    case tourEditor(tourId: String)
}
