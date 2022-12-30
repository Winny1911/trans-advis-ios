//
//  ContractorResponseModel.swift
//  TA
//
//  Created by Dev on 17/12/21.
//

import Foundation

// MARK: - Welcome
struct ContractorResponseModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let listing: [Listing]?
    let count: Int?
}

// MARK: - Listing
struct Listing: Codable {
    let id: Int?
    let firstName, lastName, email: String?
    let isBlocked, emailVerified: Int?
    let zipCode, addressLine1, addressLine2, state: String?
    let city: String?
    let country: Country?
    let phoneNumber: String?
    let profilePic: String?
    let accessToken, skillSet: String?
    let isRecommended: Int?
    let rating: String?
    let completedProjectCount: Int?
    let userFiles: [UserFile]?
    let userSkills: [UserSkills]?
    
    var licenceNumber: String?
    var profileStatus: Int?
    var createdAt: String?
    var productsCount: Int?
    //        var userFiles: [UserFile]?
    var productsDetails: [ProductsDetail]?
    
    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, email, isBlocked, emailVerified, zipCode, addressLine1, addressLine2, state, city, country, phoneNumber, licenceNumber, productsCount, createdAt, profileStatus, profilePic, accessToken, skillSet, isRecommended, rating, completedProjectCount
        case userFiles = "user_files"
        case productsDetails = "products_Details"
        case userSkills
    }
}

enum Country: String, Codable {
    case us = "US"
    case noCountry = ""
}

// MARK: - UserFile
struct UserFile: Codable {
    let id: Int?
    let title: String?
    let file: String?
    let type: String?
    let isDeleted: Int?
    let createdAt, updatedAt: String?
}

enum TypeEnum: String, Codable {
    case jpeg = "jpeg"
    case jpg = "jpg"
    case png = "png"
}

// MARK: - UserSkill
struct UserSkill: Codable {
    let id, userID: Int?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case name
    }
}


