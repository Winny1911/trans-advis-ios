//
//  RatingImageResponseModel.swift
//  TA
//
//  Created by Applify on 18/01/22.
//

import Foundation

// MARK: - RatingImageResponseModel
struct RatingImageResponseModel: Codable {
    let statusCode: Int
    let message: String
    let data: ratingImageData
}

// MARK: - DataClass
struct ratingImageData: Codable {
    let listing: [ImageListing]
}

// MARK: - Listing
struct ImageListing: Codable {
    let id: Int
    let title: String
    let file: String
    let type: String
    let projectID, userID, ratingID, isBlocked: Int
    let isDeleted: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, title, file, type
        case projectID = "projectId"
        case userID = "userId"
        case ratingID = "ratingId"
        case isBlocked, isDeleted, createdAt, updatedAt
    }
}
