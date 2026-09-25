import Foundation
@testable import OurMemory

final class FakeToursRepository: ToursRepository {
    var tours: [Tour]
    var error: Error?
    private(set) var invalidations = 0

    init(tours: [Tour] = [], error: Error? = nil) {
        self.tours = tours
        self.error = error
    }

    func allTours() async throws -> [Tour] {
        if let error {
            throw error
        }
        return tours
    }

    func invalidate() {
        invalidations += 1
    }
}
