import Foundation

nonisolated enum ApprovalUpdates {
    private static let veteransInfoField = "veteransInfo"

    static func updates(
        for approval: SubmissionApproval,
        currentInfo: [String],
        reviewer: String,
        reviewedAt: Any
    ) -> [String: Any] {
        let submissionPath = "\(DatabaseNodes.submissions)/\(approval.submission.id)"
        let editedText = approval.editedText.trimmingCharacters(in: .whitespacesAndNewlines)
        let photos = approval.approvedPhotoUrls.map { url in
            return "\(url)\(VeteranInfoFormat.descriptionSeparator)\(approval.photoCaption)"
        }
        let newInfo = currentInfo + (editedText.isEmpty ? [] : [editedText]) + photos
        let veteranPath = "\(DatabaseNodes.veterans)/\(VeteranKeys.forId(approval.submission.veteranId))"
        return [
            "\(veteranPath)/\(veteransInfoField)": newInfo,
            "\(submissionPath)/status": SubmissionStatusValues.approved,
            "\(submissionPath)/reviewedBy": reviewer,
            "\(submissionPath)/reviewedAt": reviewedAt,
            "\(submissionPath)/reply": approval.reply.trimmingCharacters(in: .whitespacesAndNewlines)
        ]
    }
}
