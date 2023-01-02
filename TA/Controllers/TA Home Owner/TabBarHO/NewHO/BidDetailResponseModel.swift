// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct BidDetailResponseModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: BidDetailData?
}

// MARK: - Datum
struct BidDetailData: Codable {
    let id, bidStatus: Int?
    let firstName, lastName: String?
    let amountCurrency, bidAmount, proposedStartDate, proposedEndDate: String?
    let amountRecievable, datumDescription, createdAt, updatedAt: String?
    let isBlocked, isDeleted, projectID, isBitAdminPermission: Int?
    let projectDetails: ProjectDetailsData?
    let user: UserDataBidDetail?
    let bidsDocuments: [BidsDocumentData]?

    enum CodingKeys: String, CodingKey {
        case id, bidStatus, amountCurrency, bidAmount, proposedStartDate, proposedEndDate, amountRecievable, firstName, lastName
        case datumDescription = "description"
        case createdAt, updatedAt, isBlocked, isDeleted
        case projectID = "projectId"
        case isBitAdminPermission
        case projectDetails = "project_details"
        case user
        case bidsDocuments = "bids_documents"
    }
}

// MARK: - BidsDocument
struct BidsDocumentData: Codable {
    let id: Int?
    let title: String?
    let file: String?
    let type: String?
    let isDeleted: Int?
    let createdAt, updatedAt: String?
    let userID: String?
    let userDetail: UserDetailData?

    enum CodingKeys: String, CodingKey {
        case id, title, file, type, isDeleted, createdAt, updatedAt
        case userID = "userId"
        case userDetail = "user_detail"
    }
}

// MARK: - UserDetail
struct UserDetailData: Codable {
    let firstName, lastName: String?
}

// MARK: - ProjectDetails
struct ProjectDetailsData: Codable {
    let id: Int?
    let title, projectDetailsDescription, type, amountCurrency: String?
    let price: Int?
    let country, state, city, addressLine1: String?
   // let addressLine2: JSONNull?
    let zipCode: String?
    let userID, isBlocked, isDeleted: Int?
    let createdAt, updatedAt: String?
    let projectFiles: [BidsDocumentData]?
    var firstName, lastName: String?

    enum CodingKeys: String, CodingKey {
        case id, title, firstName, lastName
        case projectDetailsDescription = "description"
        case type, amountCurrency, price, country, state, city, addressLine1, zipCode
        case userID = "userId"
        case isBlocked, isDeleted, createdAt, updatedAt
        case projectFiles = "project_files"
    }
}

// MARK: - User
struct UserDataBidDetail: Codable {
    let id: Int?
    let firstName, lastName, email: String?
    let isBlocked, emailVerified: Int?
    let zipCode, addressLine1, addressLine2, state: String?
    let city, country, phoneNumber: String?
    let profilePic: String?
    let skillSet, rating: String?
    let completedProjectCount: Int?
    let userFiles: [BidsDocumentData]?

    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, email, isBlocked, emailVerified, zipCode, addressLine1, addressLine2, state, city, country, phoneNumber, profilePic, skillSet, rating, completedProjectCount
        case userFiles = "user_files"
    }
}

//// MARK: - Encode/decode helpers
//
//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
//
//    public var hashValue: Int {
//        return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}
