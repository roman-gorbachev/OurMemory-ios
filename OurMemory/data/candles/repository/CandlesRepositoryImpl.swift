import Combine
import Foundation

final class CandlesRepositoryImpl: CandlesRepository {
    private let remoteDataSource: CandlesRemoteDataSource
    private let localDataSource: CandlesLocalDataSource
    private let calendar: Calendar
    private let now: () -> Date

    init(
        remoteDataSource: CandlesRemoteDataSource,
        localDataSource: CandlesLocalDataSource,
        calendar: Calendar,
        now: @escaping () -> Date
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.calendar = calendar
        self.now = now
    }

    func candleStatePublisher(veteranId: String) -> AnyPublisher<CandleState, Error> {
        return remoteDataSource.candlesPublisher(veteranId: veteranId)
            .combineLatest(localDataSource.lastLitDatePublisher(veteranId: veteranId).setFailureType(to: Error.self))
            .map { [weak self] count, lastLitDate in
                return CandleState(count: count, isLitToday: lastLitDate == self?.today())
            }
            .eraseToAnyPublisher()
    }

    func lightCandle(veteranId: String) async throws {
        let today = today()
        guard localDataSource.lastLitDate(veteranId: veteranId) != today else {
            return
        }
        try await remoteDataSource.lightCandle(veteranId: veteranId)
        localDataSource.saveLastLitDate(veteranId: veteranId, date: today)
    }

    private func today() -> String {
        return IsoDate(date: now(), calendar: calendar).text
    }
}
