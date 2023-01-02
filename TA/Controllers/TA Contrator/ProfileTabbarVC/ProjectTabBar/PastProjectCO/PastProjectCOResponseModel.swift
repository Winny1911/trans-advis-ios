//
//  PastProjectCOResponseModel.swift
//  TA
//
//  Created by Applify on 02/02/22.
//


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let pastProjectCOResponseModel = try? newJSONDecoder().decode(PastProjectCOResponseModel.self, from: jsonData)

import Foundation

struct PastProjectDetailResponseModel : Codable {
    var message : String?
    var statusCode : Int?
    var data : PastProjectDetailData?
}

struct PastProjectDetailData : Codable {
    var allProjects : PastProjectCOProjectDetail?
}

// MARK: - PastProjectCOResponseModel
struct PastProjectCOResponseModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: PastProjectCOData?
}

// MARK: - DataClass
struct PastProjectCOData: Codable {
    let allProjects: [PastProjectCOProjectDetail]?
    let count: Int?
}

// MARK: - AllProject
struct PastProjectCOProjectDetail: Codable {
    let id: Int?
    let createdAt: String?
    let projectID: Int?
    let projectDetails: PastProjectDetails?

    enum CodingKeys: String, CodingKey {
        case id, createdAt
        case projectID = "projectId"
        case projectDetails = "project_details"
    }
}

// MARK: - ProjectDetails
struct PastProjectDetails: Codable {
    let id: Int?
    let title, projectDetailsDescription: String?
    let projectType: Int?
    let type, amountCurrency: String?
    let price: Int?
    let country, state, city, addressLine1, addressLine2: String?
//    let addressLine2: JSONNull?
    let zipCode: String?
    let userID, isBlocked, isDeleted: Int?
    let createdAt, updatedAt: String?
    let status: Int?
    let userData: COPastUserData?
    let projectFiles: [COPastProjectFile]?
    let bids: [COPastBid]?
//    let homeownerRating: JSONNull?
    let contractorRating: ContractorRating?
    let tasks: [COPastTask]?
    let progress : String?
    var projectdeliverabless: [ProjectDeliverablesss]?
    let projectAgreementssss: [ProjectAgreementssss]?
    let projectCategory: ProjectCategoryesss?

    enum CodingKeys: String, CodingKey {
        case id, title
        case projectDetailsDescription = "description"
        case projectType, type, amountCurrency, price, country, state, city, addressLine1, zipCode, addressLine2
        case userID = "userId"
        case isBlocked, isDeleted, createdAt, updatedAt, status
        case userData = "user_data"
        case projectFiles = "project_files"
        case bids
        case projectAgreementssss = "project_agreementssss"
//        case homeownerRating = "homeowner_rating"
        case contractorRating = "contractor_rating"
        case tasks
        case progress
        case projectdeliverabless = "project_deliverable"
        case projectCategory
    }
}

struct ProjectCategoryesss: Codable {
    let id: Int?
    let title: String?
}

// MARK: - Bid
struct COPastBid: Codable {
    let id, userID, projectID: Int?
    let amountCurrency, bidAmount, amountRecievable, bidDescription: String?
    let proposedStartDate, proposedEndDate: String?
    let bidStatus, isDeleted: Int?
    let createdAt, updatedAt: String?
    let contractorssss: Contractorssss?
    let bidsDocuments: [COPastProjectFile]?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case projectID = "projectId"
        case amountCurrency, bidAmount, amountRecievable
        case bidDescription = "description"
        case proposedStartDate, proposedEndDate, bidStatus, isDeleted, createdAt, updatedAt, contractorssss
        case bidsDocuments = "bids_documents"
    }
}

// MARK: - ProjectFile
struct COPastProjectFile: Codable {
    let id: Int?
    let title: String?
    let file: String?
    let type: String?
    let isDeleted: Int?
    let createdAt, updatedAt: String?
    let userID: String?

    enum CodingKeys: String, CodingKey {
        case id, title, file, type, isDeleted, createdAt, updatedAt
        case userID = "userId"
    }
}

// MARK: - Contractorssss
struct Contractorssss: Codable {
    let id: Int?
    let firstName, lastName, createdAt, email: String?
    let phoneNumber: String?
}

// MARK: - ContractorRating
struct ContractorRating: Codable {
    let id, projectID, contractorID, userID: Int?
    let rating: Int?
    let feedback1, feedback2, feedback3, overAllFeedback: String?
    let isDeleted, isBlocked: Int?
    let createdAt, updatedAt: String?
    let ratingImages: [COPastRatingImage]?

    enum CodingKeys: String, CodingKey {
        case id
        case projectID = "projectId"
        case contractorID = "contractorId"
        case userID = "userId"
        case rating, feedback1, feedback2, feedback3, overAllFeedback, isDeleted, isBlocked, createdAt, updatedAt
        case ratingImages = "rating_images"
    }
}

// MARK: - RatingImage
struct COPastRatingImage: Codable {
    let id: Int?
    let title: String?
    let file: String?
    let type: String?
    let projectID, userID, ratingID, isBlocked: Int?
    let isDeleted: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, title, file, type
        case projectID = "projectId"
        case userID = "userId"
        case ratingID = "ratingId"
        case isBlocked, isDeleted, createdAt, updatedAt
    }
}

// MARK: - Task
struct COPastTask: Codable {
    let id: Int?
    let task: String?
    let userID, status, projectID, isDeleted: Int?
    let isBlocked: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, task
        case userID = "userId"
        case status
        case projectID = "projectId"
        case isDeleted, isBlocked, createdAt, updatedAt
    }
}

// MARK: - UserData
struct COPastUserData: Codable {
    var id : Int?
    let firstName, lastName: String?
    let profilePic: String?
}

// MARK: - ProjectAgreementssss
struct ProjectAgreementssss: Codable {
    let id: Int?
    let title: String?
    let file: String?
    let type: String?
    let projectID, userID: Int?
    let ratingID: Int?
    let isBlocked, isDeleted: Int?
    let createdAt, updatedAt: String?
    let userType: String?

    enum CodingKeys: String, CodingKey {
        case id, title, file, type
        case projectID = "projectId"
        case userID = "userId"
        case ratingID = "ratingId"
        case isBlocked, isDeleted, createdAt, updatedAt, userType
    }
}

// MARK: - Encode/decode helpers
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

