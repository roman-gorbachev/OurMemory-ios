import XCTest
@testable import OurMemory

final class ApprovalUpdatesTests: XCTestCase {
    private static let reviewedAt: Int64 = 1_700_000_000_000

    private func approval(editedText: String, photos: [String]) -> SubmissionApproval {
        return SubmissionApproval(
            submission: Submission(
                id: "s1",
                veteranId: "10",
                text: "",
                contact: "",
                photoPaths: [],
                status: .pending,
                createdAt: 0
            ),
            editedText: editedText,
            approvedPhotoUrls: photos,
            photoCaption: "Из семейного архива"
        )
    }

    func testApprovalAppendsTextAndSelectedPhotosAndMarksApproved() {
        let updates = ApprovalUpdates.updates(
            for: approval(editedText: "  Письмо с фронта ", photos: ["https://a"]),
            currentInfo: ["Абзац"],
            reviewer: "admin@memory.by",
            reviewedAt: Self.reviewedAt
        )
        XCTAssertEqual(
            updates["Veterans/veteran10/veteransInfo"] as? [String],
            ["Абзац", "Письмо с фронта", "https://a|Из семейного архива"]
        )
        XCTAssertEqual(updates["Submissions/s1/status"] as? String, "approved")
        XCTAssertEqual(updates["Submissions/s1/reviewedBy"] as? String, "admin@memory.by")
        XCTAssertEqual(updates["Submissions/s1/reviewedAt"] as? Int64, Self.reviewedAt)
    }

    func testBlankTextIsSkipped() {
        let updates = ApprovalUpdates.updates(
            for: approval(editedText: "   ", photos: ["https://a", "https://b"]),
            currentInfo: [],
            reviewer: "",
            reviewedAt: Self.reviewedAt
        )
        XCTAssertEqual(
            updates["Veterans/veteran10/veteransInfo"] as? [String],
            ["https://a|Из семейного архива", "https://b|Из семейного архива"]
        )
    }
}
