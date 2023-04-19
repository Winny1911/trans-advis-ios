

import Foundation

// MARK: - ViewBidsResponseModel
struct ViewBidsResponseModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: [AllProjectViewBidData]?
}

// MARK: - ViewBidsResponseModel
struct ViewBidsResponseModelHO: Codable {
    let statusCode: Int?
    let message: String?
    let data: BidUpdateResponseHO?
}

struct BidUpdateResponseHO: Codable {
    let statusCode: Int?
    let customMessage : String?
    let type : String?
}

// MARK: - Datum
struct AllProjectViewBidData: Codable {
    let id, bidStatus: Int?
    let amountCurrency, bidAmount, proposedStartDate, proposedEndDate: String?
    let amountRecievable, datumDescription, createdAt, updatedAt: String?
    let isBlocked, isDeleted, projectID, isBitAdminPermission: Int?
    let projectDetails: ProjectDetailsViewBidsData?
    let user: UserViewBid?
    let bidsDocuments: [BidsDocumentViewBid]?
   // let projectAgreement: [JSONAny]

    enum CodingKeys: String, CodingKey {
        case id, bidStatus, amountCurrency, bidAmount, proposedStartDate, proposedEndDate, amountRecievable
        case datumDescription = "description"
        case createdAt, updatedAt, isBlocked, isDeleted
        case projectID = "projectId"
        case isBitAdminPermission
        case projectDetails = "project_details"
        case user
        case bidsDocuments = "bids_documents"
       // case projectAgreement = "project_agreement"
    }
}

// MARK: - BidsDocument
struct BidsDocumentViewBid: Codable {
    let id: Int?
    let title: String?
    let file: String?
    let type: String?
    let isDeleted: Int?
    let createdAt, updatedAt: String?
    let userID: String?
    let userDetail: UserDetailViewBid?

    enum CodingKeys: String, CodingKey {
        case id, title, file, type, isDeleted, createdAt, updatedAt
        case userID = "userId"
        case userDetail = "user_detail"
    }
}

// MARK: - UserDetail
struct UserDetailViewBid: Codable {
    let firstName, lastName: String?
}

// MARK: - ProjectDetails
struct ProjectDetailsViewBidsData: Codable {
    let id: Int?
    let title, projectDetailsDescription, type, amountCurrency: String?
    let price: Int?
    let country, state, city, addressLine1: String?
    //let addressLine2: JSONNull?
    let zipCode: String?
    let userID, isBlocked, isDeleted: Int?
    let createdAt, updatedAt: String?
   // let projectAgreementsss: [JSONAny]
    let projectFiles: [BidsDocumentViewBid]?

    enum CodingKeys: String, CodingKey {
        case id, title
        case projectDetailsDescription = "description"
        case type, amountCurrency, price, country, state, city, addressLine1, zipCode
        case userID = "userId"
        case isBlocked, isDeleted, createdAt, updatedAt
       // case projectAgreementsss = "project_agreementsss"
        case projectFiles = "project_files"
    }
}

// MARK: - User
struct UserViewBid: Codable {
    let id: Int?
    let firstName, lastName, email: String?
    let isBlocked, emailVerified: Int?
    let zipCode, addressLine1, addressLine2, state: String?
    let city, country, phoneNumber: String?
    let profilePic: String?
    let skillSet, rating: String?
    let completedProjectCount: Int?
    let userFiles: [BidsDocumentViewBid]?

    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, email, isBlocked, emailVerified, zipCode, addressLine1, addressLine2, state, city, country, phoneNumber, profilePic, skillSet, rating, completedProjectCount
        case userFiles = "user_files"
    }
}


