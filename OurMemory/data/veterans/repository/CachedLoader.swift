import Foundation

final class CachedLoader<Value> {
    private let load: () async throws -> Value
    private var task: Task<Value, Error>?

    init(load: @escaping () async throws -> Value) {
        self.load = load
    }

    func value() async throws -> Value {
        if let task {
            return try await task.value
        }
        let newTask = Task { return try await load() }
        task = newTask
        do {
            return try await newTask.value
        } catch {
            if task == newTask {
                task = nil
            }
            throw error
        }
    }

    func invalidate() {
        task = nil
    }
}
