//
//  ProfileResponseModel.swift
//  TA
//
//  Created by Designer on 06/01/22.
//

import Foundation

// MARK: - ContractorProfile
struct ContractorProfileModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: ContractorUserData?
}

// MARK: - DataClass
struct ContractorUserData: Codable {
    let id: Int?
    let firstName, lastName, email: String?
    let isBlocked, emailVerified: Int?
    let zipCode, addressLine1, addressLine2, state: String?
    let city, country, phoneNumber: String?
    let profilePic: String?
    let contractorDeepLink, venderDeepLink: String?
    let accessToken, userType, licenceNumber, resetPasswordToken: String?
    let skillSet: String? //[UserSkills]?
    let userSkills: [UserSkills]?
    let profileStatus: Int?
    let rating: String?
    let projectCount: Int?
    var latitude : String?
    var longitude : String?
//    let userFiles: [ReviewUser]
    let portfolioImages: [PortfolioImage]?
    let userDocuments: [ReviewUser]

    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, email, isBlocked, emailVerified, zipCode, addressLine1, addressLine2, state, city, country, phoneNumber, profilePic, accessToken, userType, licenceNumber, resetPasswordToken, skillSet, profileStatus, rating, projectCount, latitude, longitude,contractorDeepLink, venderDeepLink
        case userSkills = "userSkills"
        case portfolioImages = "portfolio_Images"
        case userDocuments
    }
}

// MARK: - PortfolioImage
struct PortfolioImage: Codable {
    let id: Int?
    let image: String?
    let file: String?
    let contractorID, isDeleted: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, image, file
        case contractorID = "contractorId"
        case isDeleted, createdAt, updatedAt
    }
}

// MARK: - User
struct ReviewUser: Codable {
    let id: Int
    let title: String
    let file: String
    let type: String
    let isDeleted: Int
    let createdAt, updatedAt: String
}

//// MARK: - UserSkill
struct UserSkills: Codable {
    let id, userId, skillId: Int?
    let name: String?
    let projectCategory: ProjectCategoryDetail?
}
