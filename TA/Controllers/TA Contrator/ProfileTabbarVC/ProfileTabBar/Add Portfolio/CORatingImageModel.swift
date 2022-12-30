//
//  CORatingImageModel.swift
//  TA
//
//  Created by Applify on 25/01/22.
//

import Foundation

import Foundation

// MARK: - CORatingImageResponseModel
struct CORatingImageResponseModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: CORatingImage?
}

// MARK: - DataClass
struct CORatingImage: Codable {
    let listing: [CORatingImageListing]?
}

// MARK: - Listing
struct CORatingImageListing: Codable {
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
