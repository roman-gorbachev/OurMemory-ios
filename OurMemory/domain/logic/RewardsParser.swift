import Foundation

nonisolated enum RewardsParser {
    private static let separator = ","

    static func parse(_ rewards: String) -> [RewardCount] {
        var order: [Reward] = []
        var counts: [Reward: Int] = [:]
        for part in rewards.components(separatedBy: separator) {
            guard let id = Int(part.trimmingCharacters(in: .whitespaces)), let reward = Reward(rawValue: id) else {
                continue
            }
            if counts[reward] == nil {
                order.append(reward)
            }
            counts[reward, default: 0] += 1
        }
        return order.map { reward in
            return RewardCount(reward: reward, count: counts[reward] ?? 0)
        }
    }

    static func counts(from rewards: String) -> [Reward: Int] {
        return Dictionary(uniqueKeysWithValues: parse(rewards).map { return ($0.reward, $0.count) })
    }

    static func rewardsString(from counts: [Reward: Int]) -> String {
        return Reward.allCases
            .flatMap { reward in
                return Array(repeating: String(reward.rawValue), count: counts[reward] ?? 0)
            }
            .joined(separator: separator)
    }
}
