import Foundation
@testable import OurMemory

final class FakeContentDataSource: ContentDataSource {
    static let newBurialId = "-Burial"
    static let newTourId = "-Tour"

    private(set) var writes: [String] = []

    func saveVeteran(_ veteran: Veteran) async throws {
        writes.append("saveVeteran \(veteran.id)")
    }

    func deleteVeteran(veteranId: String) async throws {
        writes.append("deleteVeteran \(veteranId)")
    }

    func newBurialId() -> String {
        return Self.newBurialId
    }

    func saveBurial(_ burial: Burial) async throws {
        writes.append("saveBurial \(burial.id)")
    }

    func newTourId() -> String {
        return Self.newTourId
    }

    func saveTour(_ tour: Tour) async throws {
        writes.append("saveTour \(tour.id)")
    }

    func deleteTour(tourId: String) async throws {
        writes.append("deleteTour \(tourId)")
    }
}
