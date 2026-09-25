import XCTest
@testable import OurMemory

final class RewardsParserTests: XCTestCase {
    func testRepeatedRewardsAreGroupedWithCountInFirstSeenOrder() {
        XCTAssertEqual(
            RewardsParser.parse("9, 11,9,5,11,9"),
            [
                RewardCount(reward: .redStar, count: 3),
                RewardCount(reward: .forCourage, count: 2),
                RewardCount(reward: .heroUssr, count: 1)
            ]
        )
    }

    func testUnknownAndMalformedIdsAreSkipped() {
        XCTAssertEqual(RewardsParser.parse("4,99,abc,"), [RewardCount(reward: .lenin, count: 1)])
    }

    func testEmptyStringHasNoRewards() {
        XCTAssertEqual(RewardsParser.parse(""), [])
    }

    func testRewardCountsRoundTrip() {
        let counts = RewardsParser.counts(from: "9,9,11,1")
        XCTAssertEqual(counts, [.redStar: 2, .forCourage: 1, .redBanner: 1])
        XCTAssertEqual(RewardsParser.rewardsString(from: counts), "1,9,9,11")
        XCTAssertEqual(RewardsParser.rewardsString(from: [:]), "")
    }
}
