import FirebaseDatabase
import Foundation

final class ContentDataSourceImpl: ContentDataSource {
    private let veterans: DatabaseReference
    private let burials: DatabaseReference
    private let tours: DatabaseReference

    init(root: DatabaseReference) {
        veterans = root.child(DatabaseNodes.veterans)
        burials = root.child(DatabaseNodes.burials)
        tours = root.child(DatabaseNodes.tours)
    }

    func saveVeteran(_ veteran: Veteran) async throws {
        try await veterans.child(VeteranKeys.forId(veteran.id)).setValue(Database.Encoder().encode(veteran))
    }

    func deleteVeteran(veteranId: String) async throws {
        try await veterans.child(VeteranKeys.forId(veteranId)).removeValue()
    }

    func newBurialId() -> String {
        return burials.childByAutoId().key ?? UUID().uuidString
    }

    func saveBurial(_ burial: Burial) async throws {
        try await burials.child(burial.id).setValue(Database.Encoder().encode(burial))
    }

    func newTourId() -> String {
        return tours.childByAutoId().key ?? UUID().uuidString
    }

    func saveTour(_ tour: Tour) async throws {
        try await tours.child(tour.id).setValue(Database.Encoder().encode(tour))
    }

    func deleteTour(tourId: String) async throws {
        try await tours.child(tourId).removeValue()
    }
}
