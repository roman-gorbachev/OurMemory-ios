import Foundation

nonisolated enum VeteranCategory: String, CaseIterable, Hashable, Sendable {
    case war = "War"
    case art = "Art"

    init(value: String) {
        self = VeteranCategory(rawValue: value) ?? .war
    }
}
