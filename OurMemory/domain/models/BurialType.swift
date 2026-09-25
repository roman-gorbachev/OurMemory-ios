import Foundation

nonisolated enum BurialType: String, CaseIterable, Hashable, Sendable {
    case grave = "GRAVE"
    case massGrave = "MASS_GRAVE"
    case monument = "MONUMENT"

    init(value: String) {
        self = BurialType(rawValue: value) ?? .grave
    }
}
