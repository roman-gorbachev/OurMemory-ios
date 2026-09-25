import Combine
import XCTest
@testable import OurMemory

final class CandlesRepositoryImplTests: XCTestCase {
    private static let veteranId = "10"

    private let remote = FakeCandlesRemote()
    private let local = FakeCandlesLocal()
    private var now = ISO8601DateFormatter().date(from: "2026-05-09T08:00:00Z") ?? Date()

    private lazy var repository = CandlesRepositoryImpl(
        remoteDataSource: remote,
        localDataSource: local,
        calendar: utcCalendar,
        now: { [unowned self] in return self.now }
    )

    private var utcCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .current
        return calendar
    }

    func testCandleCanBeLitOnlyOncePerDay() async throws {
        try await repository.lightCandle(veteranId: Self.veteranId)
        try await repository.lightCandle(veteranId: Self.veteranId)
        let state = try await repository.candleStatePublisher(veteranId: Self.veteranId).firstValue()
        XCTAssertEqual(state.count, 1)
        XCTAssertTrue(state.isLitToday)
    }

    func testCandleCanBeLitAgainNextDay() async throws {
        try await repository.lightCandle(veteranId: Self.veteranId)
        now = ISO8601DateFormatter().date(from: "2026-05-10T08:00:00Z") ?? Date()
        let nextDay = try await repository.candleStatePublisher(veteranId: Self.veteranId).firstValue()
        XCTAssertFalse(nextDay.isLitToday)
        try await repository.lightCandle(veteranId: Self.veteranId)
        let state = try await repository.candleStatePublisher(veteranId: Self.veteranId).firstValue()
        XCTAssertEqual(state.count, 2)
    }
}

private final class FakeCandlesRemote: CandlesRemoteDataSource {
    let counts = CurrentValueSubject<[String: Int64], Error>([:])

    func candlesPublisher(veteranId: String) -> AnyPublisher<Int64, Error> {
        return counts.map { return $0[veteranId] ?? 0 }.eraseToAnyPublisher()
    }

    func lightCandle(veteranId: String) async throws {
        var value = counts.value
        value[veteranId, default: 0] += 1
        counts.send(value)
    }
}

private final class FakeCandlesLocal: CandlesLocalDataSource {
    let dates = CurrentValueSubject<[String: String], Never>([:])

    func lastLitDatePublisher(veteranId: String) -> AnyPublisher<String?, Never> {
        return dates.map { return $0[veteranId] }.eraseToAnyPublisher()
    }

    func lastLitDate(veteranId: String) -> String? {
        return dates.value[veteranId]
    }

    func saveLastLitDate(veteranId: String, date: String) {
        var value = dates.value
        value[veteranId] = date
        dates.send(value)
    }
}
