import Foundation

enum VeteranDestination: Hashable {
    case details(veteranId: String)
    case submission(veteranId: String)
    case feedback(veteranId: String)
}
