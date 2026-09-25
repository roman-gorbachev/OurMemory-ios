import Foundation
@testable import OurMemory

final class FakeVeteransRepository: VeteransRepository {
    var veterans: [Veteran]
    var error: Error?
    private(set) var invalidations = 0

    init(veterans: [Veteran] = [], error: Error? = nil) {
        self.veterans = veterans
        self.error = error
    }

    func allVeterans() async throws -> [Veteran] {
        if let error {
            throw error
        }
        return veterans
    }

    func resolveDirectUrl(_ url: String) async -> String {
        return url
    }

    func invalidate() {
        invalidations += 1
    }
}
