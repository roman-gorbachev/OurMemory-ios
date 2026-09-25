import Combine
import Foundation

final class MyRequestsRepositoryImpl: MyRequestsRepository {
    private static let millisecondsPerSecond = 1000.0

    private let dataSource: MyRequestsDataSource
    private let seenDataSource: RequestsSeenLocalDataSource
    private let now: () -> Date

    init(dataSource: MyRequestsDataSource, seenDataSource: RequestsSeenLocalDataSource, now: @escaping () -> Date) {
        self.dataSource = dataSource
        self.seenDataSource = seenDataSource
        self.now = now
    }

    func myRequestsPublisher() -> AnyPublisher<[MyRequest], Error> {
        let dataSource = dataSource
        return dataSource.currentUidPublisher()
            .removeDuplicates()
            .setFailureType(to: Error.self)
            .map { uid -> AnyPublisher<[MyRequest], Error> in
                guard let uid else {
                    return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
                }
                return dataSource.submissionsPublisher(authorUid: uid)
                    .combineLatest(dataSource.feedbackPublisher(authorUid: uid))
                    .map { submissions, feedback in
                        return (submissions.map { return $0.toMyRequest() } + feedback.map { return $0.toMyRequest() })
                            .filter { return !$0.id.trimmingCharacters(in: .whitespaces).isEmpty }
                            .sorted { return $0.createdAt > $1.createdAt }
                    }
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }

    func unseenCountPublisher() -> AnyPublisher<Int, Never> {
        return myRequestsPublisher()
            .replaceError(with: [])
            .combineLatest(seenDataSource.seenAtPublisher())
            .map { requests, seenAt in return requests.filter { return $0.reviewedAt > seenAt }.count }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    func markAllSeen() {
        seenDataSource.saveSeenAt(Int64(now().timeIntervalSince1970 * Self.millisecondsPerSecond))
    }
}
