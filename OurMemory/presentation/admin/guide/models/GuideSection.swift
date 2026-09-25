import SwiftUI

enum GuideSection: CaseIterable, Hashable {
    case burial
    case veteran
    case tour
    case voiceOver
    case requests
    case troubleshooting

    var titleKey: LocalizedStringKey {
        switch self {
        case .burial:
            return "burial_place"
        case .veteran:
            return "veteran"
        case .tour:
            return "tour"
        case .voiceOver:
            return "voice_over"
        case .requests:
            return "requests_and_messages"
        case .troubleshooting:
            return "if_something_is_wrong"
        }
    }

    var systemImage: String {
        switch self {
        case .burial:
            return "building.columns"
        case .veteran:
            return "person"
        case .tour:
            return "figure.walk"
        case .voiceOver:
            return "mic"
        case .requests:
            return "envelope"
        case .troubleshooting:
            return "questionmark.circle"
        }
    }

    var stepsKey: String {
        switch self {
        case .burial:
            return "burial_place_steps"
        case .veteran:
            return "veteran_steps"
        case .tour:
            return "tour_steps"
        case .voiceOver:
            return "voice_over_steps"
        case .requests:
            return "requests_steps"
        case .troubleshooting:
            return "troubleshooting_steps"
        }
    }

    var tipKey: LocalizedStringKey {
        switch self {
        case .burial:
            return "check_new_marker_msg"
        case .veteran:
            return "save_button_disabled_msg"
        case .tour:
            return "stop_order_sets_route_msg"
        case .voiceOver:
            return "check_stresses_before_msg"
        case .requests:
            return "reply_shown_to_author_msg"
        case .troubleshooting:
            return "deleted_items_cannot_be_restored_msg"
        }
    }

    var steps: [String] {
        return L10n.string(stepsKey).components(separatedBy: "\n").filter { return !$0.isBlank }
    }
}
