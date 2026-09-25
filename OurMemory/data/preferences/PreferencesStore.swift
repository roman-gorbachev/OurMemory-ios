import Combine
import Foundation

final class PreferencesStore {
    private let defaults: UserDefaults
    private let changes = PassthroughSubject<Void, Never>()

    init(defaults: UserDefaults) {
        self.defaults = defaults
    }

    func publisher<Value: Equatable>(_ read: @escaping (UserDefaults) -> Value) -> AnyPublisher<Value, Never> {
        return changes
            .map { [defaults] in return read(defaults) }
            .prepend(Deferred { [defaults] in return Just(read(defaults)) })
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    func read<Value>(_ read: (UserDefaults) -> Value) -> Value {
        return read(defaults)
    }

    func edit(_ write: (UserDefaults) -> Void) {
        write(defaults)
        changes.send()
    }
}
