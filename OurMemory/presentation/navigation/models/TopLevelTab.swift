import SwiftUI

enum TopLevelTab: CaseIterable, Hashable {
    case veterans
    case map
    case about
    case more
    case admin

    var systemImage: String {
        switch self {
        case .veterans:
            return "person"
        case .map:
            return "map"
        case .about:
            return "building.columns"
        case .more:
            return "ellipsis"
        case .admin:
            return "shield"
        }
    }

    var titleKey: LocalizedStringKey {
        switch self {
        case .veterans:
            return "veterans"
        case .map:
            return "map"
        case .about:
            return "about_cemetery"
        case .more:
            return "more"
        case .admin:
            return "admin"
        }
    }
}
