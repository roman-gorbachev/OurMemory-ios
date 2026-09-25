import Foundation

nonisolated extension FeedbackDto {
    func toDomainModel() -> Feedback {
        return Feedback(
            id: id,
            type: FeedbackType(rawValue: type) ?? .other,
            text: text,
            contact: contact,
            veteranId: veteranId,
            isReviewed: status == FeedbackStatusValues.done,
            createdAt: createdAt,
            reply: reply,
            reviewedAt: reviewedAt
        )
    }

    func toMyRequest() -> MyRequest {
        return MyRequest(
            id: id,
            kind: .feedback,
            veteranId: veteranId,
            text: text,
            status: status == FeedbackStatusValues.done ? .reviewed : .inReview,
            reply: reply,
            createdAt: createdAt,
            reviewedAt: reviewedAt
        )
    }
}
