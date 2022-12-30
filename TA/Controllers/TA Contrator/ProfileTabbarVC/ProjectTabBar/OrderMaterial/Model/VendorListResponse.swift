//
//  VendorListResponse.swift
//  TA
//
//  Created by Shikha Pandey on 07/02/22.
//

import Foundation






// MARK: - VendorListResponse
struct VendorDataResponse: Codable {
    let statusCode: Int
    let message: String
    let data: VendorListResponseModel
}

// MARK: - DataClass
struct VendorListResponseModel: Codable {
    var vendors: Int?
    var listing: [Listing]?

    enum CodingKeys: String, CodingKey {
        case vendors = "Vendors"
        case listing
    }
}


//// MARK: - DataClass
//struct VendorListResponseModel: Codable {
//    let allProjects: [VendorListResponse]
//    let count: Int
//}

// MARK: - AllProject
struct VendorListResponse: Codable {
    let id: Int
    let createdAt: String
    let projectID: Int
//    let project, progress: JSONNull?
    let projectDetails: ProjectDetails
    let projectAgreements: [ProjectAgreement]

    enum CodingKeys: String, CodingKey {
            case id, createdAt
            case projectID = "projectId"
            case projectDetails = "project_details"
            case projectAgreements = "project_agreements"
        }
}

/*// MARK: - ProjectDetails
struct ProjectDetails: Codable {
    let id: Int
    let title: String
    let projectDetailsDescription: JSONNull?
    let type: String
    let projectType: Int
    let amountCurrency: String
    let price: Int
    let country, state, city, addressLine1: String
    let addressLine2: String?
    let zipCode: String
    let userID, isBlocked, isDeleted: Int
    let createdAt, updatedAt: String
    let status: Int
    let userData: UserData
    let projectFiles: [ProjectFile]
    let contractorRating, homeownerRating: JSONNull?
    let bids: [Bid]
    let tasks: [Task]

    enum CodingKeys: String, CodingKey {
        case id, title
        case projectDetailsDescription
        case type, projectType, amountCurrency, price, country, state, city, addressLine1, addressLine2, zipCode
        case userID
        case isBlocked, isDeleted, createdAt, updatedAt, status
        case userData
        case projectFiles
        case contractorRating
        case homeownerRating
        case bids, tasks
    }
}*/

// MARK: - ProductsDetail
struct ProductsDetail: Codable {
    var id: Int?
    var name, productsDetailDescription, size: String?
    var amountCurrency: AmountCurrency?
    var price: Int?
    var weight, brand: String?
    var category: String?
    var subCategory, material: String?
    var userID, isBlocked, isDeleted: Int?
    var createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case productsDetailDescription = "description"
        case size, amountCurrency, price, weight, brand, category, subCategory, material
        case userID = "userId"
        case isBlocked, isDeleted, createdAt, updatedAt
    }
}

enum AmountCurrency: String, Codable {
    case usd = "USD"
}


// MARK: - UserData
struct UserData: Codable {
    let firstName, lastName: String
    let profilePic: String
}
