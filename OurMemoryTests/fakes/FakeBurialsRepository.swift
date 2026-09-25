import Foundation
@testable import OurMemory

final class FakeBurialsRepository: BurialsRepository {
    var burials: [Burial]
    var error: Error?
    private(set) var invalidations = 0

    init(burials: [Burial] = [], error: Error? = nil) {
        self.burials = burials
        self.error = error
    }

    func allBurials() async throws -> [Burial] {
        if let error {
            throw error
        }
        return burials
    }

    func originalBurials() async throws -> [Burial] {
        return try await allBurials()
    }

    func invalidate() {
        invalidations += 1
    }
}
