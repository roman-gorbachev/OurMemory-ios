import Foundation

nonisolated extension SubmissionDto {
    func toDomainModel() -> Submission {
        let moderationStatus: ModerationStatus
        switch status {
        case SubmissionStatusValues.approved:
            moderationStatus = .approved
        case SubmissionStatusValues.rejected:
            moderationStatus = .rejected
        default:
            moderationStatus = .pending
        }
        return Submission(
            id: id,
            veteranId: veteranId,
            text: text,
            contact: contact,
            photoPaths: photoPaths,
            status: moderationStatus,
            createdAt: createdAt,
            reply: reply,
            reviewedAt: reviewedAt
        )
    }

    func toMyRequest() -> MyRequest {
        let requestStatus: RequestStatus
        switch status {
        case SubmissionStatusValues.approved:
            requestStatus = .approved
        case SubmissionStatusValues.rejected:
            requestStatus = .rejected
        default:
            requestStatus = .inReview
        }
        return MyRequest(
            id: id,
            kind: .submission,
            veteranId: veteranId,
            text: text,
            status: requestStatus,
            reply: reply,
            createdAt: createdAt,
            reviewedAt: reviewedAt
        )
    }
}
