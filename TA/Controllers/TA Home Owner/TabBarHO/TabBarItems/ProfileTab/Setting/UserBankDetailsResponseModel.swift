//
//  UserBankDetailsResponseModel.swift
//  TA
//
//  Created by Applify on 17/01/22.
//

import Foundation

// MARK: - UserBankDetailsResponseModel
struct UserBankDetailsResponseModel: Codable {
    let statusCode: Int?
    let message: String?
    let data: UserBankDetails?
}

// MARK: - DataClass
struct UserBankDetails: Codable {
    let count: Int?
    let listing: [UserListing]?
}

// MARK: - Listing
struct UserListing: Codable {
    let id: Int?
    let accountHolderName, accountNo, routingNumber, ssn: String?
    let isBlocked: Int?
}
