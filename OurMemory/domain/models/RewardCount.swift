import Foundation

nonisolated struct RewardCount: Hashable, Sendable {
    let reward: Reward
    let count: Int
}
