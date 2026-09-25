import Foundation

nonisolated struct SubmissionDto: Decodable, Hashable, Sendable {
    var id = ""
    var veteranId = ""
    var text = ""
    var contact = ""
    var photoPaths: [String] = []
    var status = ""
    var createdAt: Int64 = 0
    var authorUid = ""
    var reply = ""
    var reviewedAt: Int64 = 0

    private enum CodingKeys: String, CodingKey {
        case id, veteranId, text, contact, photoPaths, status, createdAt, authorUid, reply, reviewedAt
    }

    init(
        id: String = "",
        veteranId: String = "",
        text: String = "",
        contact: String = "",
        photoPaths: [String] = [],
        status: String = "",
        createdAt: Int64 = 0,
        authorUid: String = "",
        reply: String = "",
        reviewedAt: Int64 = 0
    ) {
        self.id = id
        self.veteranId = veteranId
        self.text = text
        self.contact = contact
        self.photoPaths = photoPaths
        self.status = status
        self.createdAt = createdAt
        self.authorUid = authorUid
        self.reply = reply
        self.reviewedAt = reviewedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = container.lenientString(forKey: .id)
        veteranId = container.lenientString(forKey: .veteranId)
        text = container.lenientString(forKey: .text)
        contact = container.lenientString(forKey: .contact)
        photoPaths = container.lenientStrings(forKey: .photoPaths)
        status = container.lenientString(forKey: .status)
        createdAt = container.lenientInt64(forKey: .createdAt)
        authorUid = container.lenientString(forKey: .authorUid)
        reply = container.lenientString(forKey: .reply)
        reviewedAt = container.lenientInt64(forKey: .reviewedAt)
    }
}
