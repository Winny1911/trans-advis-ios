//
//  CategoryResponse.swift
//  TA
//
//  Created by Shikha Pandey on 08/02/22.
//

import Foundation

// MARK: - CategoryResponse
struct CategoryResponse: Codable {
    var statusCode: Int?
    var message: String?
    var data: CategoryResponseData?
}

// MARK: - DataClass
struct CategoryResponseData: Codable {
    var count: Int?
    var listing: [Categories]?
}

// MARK: - Listing
struct Categories: Codable {
    var id: Int?
    var title, listingDescription: String?
    var isBlocked: Int?

    enum CodingKeys: String, CodingKey {
        case id, title
        case listingDescription = "description"
        case isBlocked
    }
}
