//
//  profileModel.swift
//  TA
//
//  Created by Designer on 31/12/21.
//

import Foundation

// MARK: - ProfileModel
struct ProfileHOModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: profileUserDetail?
}

// MARK: - DataClass
struct profileUserDetail: Codable {
    let id: Int?
    let firstName, lastName, email: String?
    let isBlocked, emailVerified: Int?
    let zipCode, addressLine1, addressLine2, state: String?
    let city, country, phoneNumber, profilePic: String?
    let accessToken, userType, licenceNumber, resetPasswordToken: String?
    let skillSet: String?
    let profileStatus: Int?
    let rating: String?
    let projectCount: Int?
    var latitude : String?
    var longitude : String?
//    let userFiles, portfolioImages,
    var userDocuments: [Usersss]?

    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, email, isBlocked, emailVerified, zipCode, addressLine1, addressLine2, state, city, country, phoneNumber, profilePic, accessToken, userType, licenceNumber, resetPasswordToken, skillSet, profileStatus, rating, projectCount,longitude,latitude
//        case userFiles = "user_files"
//        case portfolioImages = "portfolio_Images"
        case userDocuments
    }
}

// MARK: - User
struct Usersss: Codable {
    let id: Int
    let title: String
    let file: String
    let type: String
    let isDeleted: Int
    let createdAt, updatedAt: String
}
