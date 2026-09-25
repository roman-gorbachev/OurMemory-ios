import Foundation

protocol ContentDataSource: AnyObject {
    func saveVeteran(_ veteran: Veteran) async throws
    func deleteVeteran(veteranId: String) async throws
    func newBurialId() -> String
    func saveBurial(_ burial: Burial) async throws
    func newTourId() -> String
    func saveTour(_ tour: Tour) async throws
    func deleteTour(tourId: String) async throws
}
