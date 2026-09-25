import Foundation

nonisolated struct FeedbackDto: Decodable, Hashable, Sendable {
    var id = ""
    var type = ""
    var text = ""
    var contact = ""
    var veteranId = ""
    var status = ""
    var createdAt: Int64 = 0
    var authorUid = ""
    var reply = ""
    var reviewedAt: Int64 = 0

    private enum CodingKeys: String, CodingKey {
        case id, type, text, contact, veteranId, status, createdAt, authorUid, reply, reviewedAt
    }

    init(
        id: String = "",
        type: String = "",
        text: String = "",
        contact: String = "",
        veteranId: String = "",
        status: String = "",
        createdAt: Int64 = 0,
        authorUid: String = "",
        reply: String = "",
        reviewedAt: Int64 = 0
    ) {
        self.id = id
        self.type = type
        self.text = text
        self.contact = contact
        self.veteranId = veteranId
        self.status = status
        self.createdAt = createdAt
        self.authorUid = authorUid
        self.reply = reply
        self.reviewedAt = reviewedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = container.lenientString(forKey: .id)
        type = container.lenientString(forKey: .type)
        text = container.lenientString(forKey: .text)
        contact = container.lenientString(forKey: .contact)
        veteranId = container.lenientString(forKey: .veteranId)
        status = container.lenientString(forKey: .status)
        createdAt = container.lenientInt64(forKey: .createdAt)
        authorUid = container.lenientString(forKey: .authorUid)
        reply = container.lenientString(forKey: .reply)
        reviewedAt = container.lenientInt64(forKey: .reviewedAt)
    }
}
